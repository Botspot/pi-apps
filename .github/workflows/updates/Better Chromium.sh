#!/bin/bash

# enable chromium-debs repo workflow (disables automatically after 60 days inactivity)
GH_TOKEN="$GH_PERSONAL_ACCESS_TOKEN" gh --repo Pi-Apps-Coders/chromium-debs workflow enable Update-Chromium.yml || warning "Failed to enable Update-Chromium action in Pi-Apps-Coders/chromium-debs"
