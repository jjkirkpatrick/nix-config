#!/usr/bin/env bash
# NemoClaw startup: gateway → provider → inference route → sandbox → port forward
set -euo pipefail

GATEWAY_NAME=openshell
GATEWAY_PORT=8085
SANDBOX_NAME=my-assistant
DASHBOARD_PORT=18789
MODEL=moonshotai/kimi-k2.5
NEMOCLAW_SOURCE="$HOME/.nemoclaw/source"

log() { echo "[nemoclaw-startup] $*"; }

# Wait for Docker (system service may not be up yet at login)
log "Waiting for Docker..."
for i in $(seq 1 24); do
  if docker info >/dev/null 2>&1; then break; fi
  sleep 5
done
if ! docker info >/dev/null 2>&1; then
  log "ERROR: Docker not available after 2 minutes"
  exit 1
fi

# Read API key
NVIDIA_API_KEY=$(node -e "const c=require(process.env.HOME+'/.nemoclaw/credentials.json'); console.log(c.NVIDIA_API_KEY)")
if [[ -z "$NVIDIA_API_KEY" ]]; then
  log "ERROR: NVIDIA_API_KEY not found in ~/.nemoclaw/credentials.json"
  exit 1
fi

# 1. Start gateway
log "Starting OpenShell gateway on port $GATEWAY_PORT..."
openshell gateway start --gpu --port "$GATEWAY_PORT" 2>&1
log "Gateway ready."

# 2. Configure inference provider
log "Configuring nvidia-nim provider..."
openshell provider delete nvidia-nim -g "$GATEWAY_NAME" 2>/dev/null || true
openshell provider create \
  --name nvidia-nim \
  --type openai \
  --credential "NVIDIA_API_KEY=$NVIDIA_API_KEY" \
  --config "OPENAI_BASE_URL=https://integrate.api.nvidia.com/v1" \
  -g "$GATEWAY_NAME"

# 3. Set inference route
log "Setting inference route (model: $MODEL)..."
openshell inference set \
  --no-verify \
  --provider nvidia-nim \
  --model "$MODEL" \
  -g "$GATEWAY_NAME"

# 4. Recreate sandbox (k3s state is ephemeral across gateway restarts)
log "Creating sandbox '$SANDBOX_NAME'..."
openshell sandbox delete "$SANDBOX_NAME" -g "$GATEWAY_NAME" 2>/dev/null || true
openshell sandbox create \
  --from "$NEMOCLAW_SOURCE/Dockerfile" \
  --name "$SANDBOX_NAME" \
  --policy "$NEMOCLAW_SOURCE/nemoclaw-blueprint/policies/openclaw-sandbox.yaml" \
  --provider nvidia-nim \
  -g "$GATEWAY_NAME" \
  -- env \
    CHAT_UI_URL="http://127.0.0.1:$DASHBOARD_PORT" \
    NVIDIA_API_KEY="$NVIDIA_API_KEY" \
    nemoclaw-start 2>&1 | tee /tmp/nemoclaw-sandbox-create.log

# 5. Port forward
log "Starting port forward $DASHBOARD_PORT → sandbox..."
openshell forward start --background "$DASHBOARD_PORT" "$SANDBOX_NAME" -g "$GATEWAY_NAME"

# Save URL for quick access
URL=$(grep -oP 'Local UI: \K\S+' /tmp/nemoclaw-sandbox-create.log 2>/dev/null || true)
if [[ -n "$URL" ]]; then
  echo "$URL" > "$HOME/.nemoclaw/dashboard-url.txt"
  log "Dashboard ready: $URL"
else
  log "Dashboard ready at: http://127.0.0.1:$DASHBOARD_PORT"
fi
