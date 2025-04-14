# Code of Conduct

## Our Pledge

In the interest of fostering an open, welcoming, and productive community, we, the maintainers and contributors of Pi-Apps, pledge to make participation in our project a harassment-free experience for anyone.

## Our Standards

Pi-Apps is a collection of app installation scripts (mostly open source projects, but also include proprietary apps) that aims to make software installation easier on Raspberry Pi and other compatible devices.

This is like the quote of this project where it says:
> Let's be honest: Linux is harder to master than Windows. Sometimes it's not user-friendly, and following an outdated tutorial may break your Raspberry Pi's operating system.
> There is no centralized software repository, except for the apt repositories which lack many desktop applications.
> Surely there is a better way! **There is.**
> Introducing Pi-Apps, a well-maintained collection of app installation-scripts that you can run with **one click**.

To maintain the quality and usability of this project, we expect all participants to adhere to the following standards:

### Examples of behavior that contributes to creating a positive environment:

* Using welcoming and inclusive language (this is a community that accepts and supports people regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation)
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members
* Providing detailed and well-written issue reports and pull requests
* Testing your contributions before submitting them

### Examples of unacceptable behavior:

* The use of sexualized language or imagery and unwelcome sexual attention or advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic address, without explicit permission
* Creating spam issues, pull requests, or comments
* Submitting poorly written or low-effort issues without proper information
* Submitting app requests without proper research or context
* Other conduct which could reasonably be considered inappropriate in a professional setting

## Specific Guidelines for Contributions

### For Issues:

1. **Search before you submit**: Make sure your issue (for example adding an app) hasn't been reported already. (this is still for now a problem and people can ignore this rule)
2. **Use the provided templates**: We have templates for bug reports, app suggestions, and general suggestions. Use them! (again this is still a problem for now, but not as often)
3. **Be specific and detailed**: Vague issues like "it doesn't work" without details will be closed. See on [how to properly make a bug report](https://www.softwaretestinghelp.com/how-to-write-good-bug-report/) for more details if you are making a bug report.
4. **Include relevant information**: For bug reports, include Pi-Apps version, operating system, and steps to reproduce.
5. **One issue per report**: Don't bundle multiple issues into one report.
6. **Format your code**: When including terminal output or code snippets, use proper markdown formatting.
7. **Be responsive**: If a maintainer asks for additional information, please respond promptly, otherwise the issue will be closed and possibly a block on any new issues if the developer sees suspicious activity on the app submissions.
8. **No spam**: Creating nonsensical issues or duplicate issues will result in a ban.
9. **Follow the app eligibility rubric**: When submitting an app, make sure it follows the app eligibility rubric, otherwise it will be closed.

### For Pull Requests:

1. **Test your changes**: Make sure your PR actually works as intended. (if the app installation is not working initially, then additional commits are expected to fix the issue before it can be merged, since the contributors can make mistakes like any unnoticed issues that don't seem to affect the installation but break at another function like updating the app are allowed to be fixed in a later PR)
2. **Describe your changes**: Include a detailed description of what your PR accomplishes. (like a detailed description of the the added app, what it does, and how it works)
3. **Keep PRs focused**: One PR should address one specific issue or add one feature.
4. **Follow existing code style**: Maintain consistency with the project's coding style. (don't be like the PR [#2545](https://github.com/Botspot/pi-apps/pull/2545) that was ignoring the structure of app installation scripts)
5. **Document your code**: Add comments to explain complex logic.
6. **Reference related issues**: If your PR addresses an existing issue, reference it.
7. **Be willing to make changes**: If reviewers suggest changes, be open to revising your PR.
8. **No spam**: Creating nonsensical PRs or duplicate PRs will result in a ban.
9. **Follow the app eligibility rubric**: When submitting an app, make sure it follows the app eligibility rubric, otherwise it will be closed.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project team. All complaints will be reviewed and investigated and will result in a response that is deemed necessary and appropriate to the circumstances. The project team is obligated to maintain confidentiality with regard to the reporter of an incident.

### Enforcement Guidelines

Project maintainers will follow these Community Impact Guidelines in determining the consequences for any action they deem in violation of this Code of Conduct:

1. **Correction**: For first-time violations or minor infractions (such as poorly written issues), a private or public message providing clarity around the nature of the violation and an explanation of why the behavior was inappropriate. A public apology may be requested.

2. **Warning**: For repeated violations or more serious infractions (such as creating multiple low-quality issues or PRs), a warning will be issued with consequences for continued behavior. No interaction with the people involved, including unsolicited interaction with those enforcing the Code of Conduct, for a specified period of time.

3. **Temporary Ban**: For serious violations of community standards, including sustained inappropriate behavior or spam issues like those observed in issues [#2736](https://github.com/Botspot/pi-apps/issues/2736), [#2735](https://github.com/Botspot/pi-apps/issues/2735), and [#523](https://github.com/Botspot/pi-apps/issues/523), a temporary ban from any sort of interaction or public communication with the community for a specified period of time.

4. **Permanent Ban**: For demonstrating a pattern of violation of community standards, including sustained inappropriate behavior, harassment of an individual, or aggression toward or disparagement of classes of individuals, a permanent ban from any sort of public interaction within the community will be issued.

Please note that before the Code of Conduct change went into place, only 1. and 4. were used for enforcing app submissions.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org), version 2.0, available at https://www.contributor-covenant.org/version/2/0/code_of_conduct.html.

Community Impact Guidelines were inspired by [Mozilla's code of conduct enforcement ladder](https://github.com/mozilla/diversity).

## Examples of Past Violations

To help clarify our standards, here are some examples of past violations:

1. **Spam Issues**: In issues [#2736](https://github.com/Botspot/pi-apps/issues/2736), [#2735](https://github.com/Botspot/pi-apps/issues/2735), and [#523](https://github.com/Botspot/pi-apps/issues/523), users posted irrelevant content (a link that was not related to anything useful), external links without context (a dummy link that clones a repo but does not provide any context and does nothing it itself, aka being a bit of a joke), or nonsensical information that did not contribute to the project. These resulted in the users being banned.

2. **Low-Effort Submissions**: Issues [#2530](https://github.com/Botspot/pi-apps/issues/2530), [#2607](https://github.com/Botspot/pi-apps/issues/2607) and [#2621](https://github.com/Botspot/pi-apps/issues/2621) contained poorly written requests or bug reports without sufficient information for maintainers to act upon. While these were legitimate app submission/suggestion concerns, they lacked the necessary details required for effective troubleshooting or consideration. For example app porting requests on Pi-Apps (ex. porting an app for a different architecture or making the app work for that platform) won't be accepted unless you made the port yourself.

3. **Improper PR Submissions**: PR [#2545](https://github.com/Botspot/pi-apps/pull/2545) by a "[Pi-Apps contributor](https://github.com/Botspot/pi-apps/pull/2545#issuecomment-1926156751)" which was confused with the [Pi Network](https://minepi.com) due to having contributions in the organization named [pi-apps](https://github.com/pi-apps), violated our contribution guidelines by not following the proper format, lacking appropriate testing, or containing multiple unrelated changes, which contained the following: 
- a [security policy](https://github.com/KOSASIH/pi-apps/blob/patch-1/SECURITY.md) that was completely inaccurate to the project's update architecture (security policy for a app which uses semantic versioning but this is a [rolling release project](https://github.com/Botspot/pi-apps/pull/2429#issuecomment-1683983116),
- submitted a [non sensible React based app](https://github.com/KOSASIH/pi-apps/tree/4a79d6bf2744eb3491502328be394467623cc975/apps/PiGenesis) but not following the format of the other apps on Pi-Apps and not following the proper npm based project setup in itself.
- added unrelated CI workflows via GitHub Actions (for things such as [building/uploading container images to the Alibaba Cloud Container Registry](https://github.com/KOSASIH/pi-apps/blob/4a79d6bf2744eb3491502328be394467623cc975/.github/workflows/alibabacloud.yml) and adding [unrelated C/C++ CI checks](https://github.com/KOSASIH/pi-apps/blob/4a79d6bf2744eb3491502328be394467623cc975/.github/workflows/c-cpp.yml)) which would interfere with the CI integration's setup on Pi-Apps.

This was a low quality PR according to the Pi-Apps contributors that was not helpful to the project and resulted in a **permanent ban** from all Botspot repositories.

Remember that everyone was new once - we aim to help you contribute effectively rather than to criticize. However, repeated violations after warnings will lead to moderation actions as outlined above.

---

By participating in the Pi-Apps project, you agree to abide by this Code of Conduct. Thank you for helping make Pi-Apps a welcoming and productive community for all. 
