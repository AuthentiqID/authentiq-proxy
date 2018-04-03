# Jenkins-behind-Authentiq 

This example shows how to protect a Jenkins server using [Authentiq](https://www.authentiq.com/?utm_source=github&utm_medium=readme&utm_campaign=authentiq-proxy-jenkins).

It runs an Nginx (actually [OpenResty](https://openresty.org/)) proxy in front of a standard Jenkins server using Docker. The proxy is responsible for authenticating users before passing them through to Jenkins.

In the [Quickstart](#quickstart) all authenticated users are given the same access privileges in Jenkins. 

Read the follow-up to understand how to configure the (included) [Reverse Proxy Auth Plugin](https://wiki.jenkins.io/display/JENKINS/Reverse+Proxy+Auth+Plugin) to secure more fine grained access controls.


# Quickstart

1. Sign in to the [Authentiq Dashboard](https://dashoard.authentiq.com/?utm_source=github&utm_medium=readme&utm_campaign=authentiq-proxy-jenkins) to create a new client for you Jenkins server.
1. Paste the `client_id` and `client_secret` into the [jenkins_access.lua](conf.d/jenkins_access.lua) file.
1. Also change the `whitelisted_domain` variable to match your email domain.
1. Run

       docker-compose up

   And access the Jenkins server via [http://localhost:8080/](http://localhost:8080/). You should be redirected to Authentiq to sign in.

Even though only people with a whitelisted email address can access the server in this configuration, Jenkins is unaware of the user who authenticated. As such, this works well if your Jenkins server has the "Enable security" feature disabled.
 
# Connecting accounts

The next two configurations use the [Reverse Proxy Auth Plugin](https://wiki.jenkins.io/display/JENKINS/Reverse+Proxy+Auth+Plugin) to retrieve the authenticated user in Jenkins.

The [Dockerfile-jenkins](Dockerfile-jenkins) in this repository has it enabled already. 

## Logged-in users can do anything

If you just want to use a different account for each user, but generally all users are equal, then enable "Logged-in users can do anything" on the [security settings page](http://localhost:8080/configureSecurity/).

 
## Access control

If you prefer to have different access rights for each user, then use the [Matrix Authorization Strategy](https://plugins.jenkins.io/matrix-auth) to define those user privileges for (some of) the authenticated users.

# Support

Do [let us know](mailto:support@authentiq.com) how you get on!
