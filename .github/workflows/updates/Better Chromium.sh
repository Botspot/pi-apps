#!/bin/bash

# enable chromium-debs repo workflow (disables automatically after 60 days inactivity)
gh --repo Pi-Apps-Coders/chromium-debs workflow enable Update-Chromium.yml || true
