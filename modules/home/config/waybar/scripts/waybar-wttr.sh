#!/bin/bash

# Weather icons mapping function
get_weather_icon() {
    case "$1" in
        "113") echo "☀️ " ;;
        "116") echo "⛅ " ;;
        "119"|"122"|"143"|"248"|"260") echo "☁️ " ;;
        "176"|"179"|"182"|"185"|"263"|"266"|"281"|"284"|"293"|"296"|"299"|"302"|"305"|"308"|"311"|"314"|"317"|"350"|"353"|"356"|"359"|"362"|"365"|"368"|"392") echo "🌧️" ;;
        "200") echo "⛈️ " ;;
        "227"|"230"|"320"|"323"|"326"|"374"|"377"|"386"|"389") echo "🌨️" ;;
        "329"|"332"|"335"|"338"|"371"|"395") echo "❄️ " ;;
        *) echo "🌡️" ;;
    esac
}

# Fetch weather data
weather_data=$(curl -s "https://wttr.in/?format=j1")
if [ $? -ne 0 ] || [ -z "$weather_data" ]; then
    echo '{"text": "🌡️ N/A", "tooltip": "Weather data unavailable"}'
    exit 0
fi

# Parse current conditions using jq
current_temp=$(echo "$weather_data" | jq -r '.current_condition[0].FeelsLikeC')
weather_code=$(echo "$weather_data" | jq -r '.current_condition[0].weatherCode')
weather_desc=$(echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value')
actual_temp=$(echo "$weather_data" | jq -r '.current_condition[0].temp_C')
wind_speed=$(echo "$weather_data" | jq -r '.current_condition[0].windspeedKmph')
humidity=$(echo "$weather_data" | jq -r '.current_condition[0].humidity')

# Check for valid data
if [ "$current_temp" == "null" ] || [ -z "$current_temp" ]; then
    echo '{"text": "🌡️ N/A", "tooltip": "Invalid weather data"}'
    exit 0
fi

# Get weather icon
weather_icon=$(get_weather_icon "$weather_code")

# Format temperature with + sign for single digits
extrachar=""
if [ "$current_temp" -gt 0 ] && [ "$current_temp" -lt 10 ]; then
    extrachar="+"
fi

# Build display text
display_text=" ${weather_icon} ${extrachar}${current_temp}°"

# Build tooltip
tooltip="<b>${weather_desc} ${actual_temp}°</b>\n"
tooltip="${tooltip}Feels like: ${current_temp}°\n"
tooltip="${tooltip}Wind: ${wind_speed}Km/h\n"
tooltip="${tooltip}Humidity: ${humidity}%\n"

# Add forecast data (simplified - just today and tomorrow)
forecast_data=$(echo "$weather_data" | jq -r '.weather[0,1] | "\(.date)|\(.maxtempF)|\(.mintempF)|\(.astronomy[0].sunrise)|\(.astronomy[0].sunset)"')
day_count=0
while IFS='|' read -r date max_temp min_temp sunrise sunset; do
    if [ $day_count -eq 0 ]; then
        tooltip="${tooltip}\n<b>Today, ${date}</b>\n"
    elif [ $day_count -eq 1 ]; then
        tooltip="${tooltip}\n<b>Tomorrow, ${date}</b>\n"
    fi
    tooltip="${tooltip}⬆️ ${max_temp}° ⬇️ ${min_temp}° 🌅 ${sunrise} 🌇 ${sunset}\n"
    day_count=$((day_count + 1))
done <<< "$forecast_data"

# Output JSON for waybar
printf '{"text": "%s", "tooltip": "%s"}' "$display_text" "$tooltip"