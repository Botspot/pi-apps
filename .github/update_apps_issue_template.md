---
title: 'CI: Update App Versions Failures'
---
[badge-error]: https://github.com/Pi-Apps-Coders/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/error.svg?raw=true 'Error'
[badge-warning]: https://github.com/Pi-Apps-Coders/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/warning.svg?raw=true 'Warning'
[badge-issue]: https://github.com/Pi-Apps-Coders/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/issue.svg?raw=true 'Issue'
[badge-check]: https://github.com/Pi-Apps-Coders/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/check.svg?raw=true 'Check'
[badge-info]: https://github.com/Pi-Apps-Coders/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/info.svg?raw=true 'Info'
Workflow run: https://github.com/{{ env.GITHUB_REPOSITORY }}/actions/runs/{{ env.GITHUB_RUN_ID }}

{{ env.FAILED_APPS }}
{{ env.ALL_FAILED_APPS_ERROR_STRING }}
