workflow "Publish Scheduled Posts" {
  resolves = ["npm run publish-scheduled"]
  on = "schedule(0/15 * * * *)"
}

action "npm install" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "install"
}

action "npm run publish-scheduled" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["npm install"]
  args = "run publish-scheduled"
  secrets = ["NETLIFY_BUILD_HOOK_URL"]
}

workflow "Update Copyright Notice" {
  resolves = ["HTTP client"]
  on = "schedule(0 0 1 1 *)"
}

action "HTTP client" {
  uses = "swinton/httpie.action@8ab0a0e926d091e0444fcacd5eb679d2e2d4ab3d"
  args = ["POST", "$NETLIFY_BUILD_HOOK_URL"]
  secrets = ["NETLIFY_BUILD_HOOK_URL"]
}

workflow "Run tests" {
  on = "push"
  resolves = ["npm test", "npm run lint"]
}

action "npm ci" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "ci --unsafe-perm"
}

action "npm test" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "test"
  needs = ["npm ci"]
}

action "npm run lint" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["npm ci"]
  args = "run lint"
}
