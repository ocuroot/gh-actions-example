# Ocuroot + GitHub Actions

This repo illustrates integrating Ocuroot with GitHub Actions, using Actions to trigger Ocuroot commands
and execute needed tasks and deployments.

## The Release Flow

The example release in `release.ocu.star` contains a pair of tasks, "build" and "approval". The build task
reads a message from `message.txt` and stores it as an output. The approval task requires human approval
via custom state, and reads the message from the build task to forward as output.

### Step 1: Release

An update to the message might look something like this:

```bash
echo "My new message" > message.txt
git add message.txt
git commit -m "Update message"
git push
```

This will trigger a workflow, which will execute the release, and will go as far as completing the build task.
Progress can be monitored via the state UI:

```bash
$ ocuroot state view
Your state view is ready and waiting!
Open your browser to: http://localhost:3000
```

### Step 2: Approval

At this point, approval can be given by setting the appropriate custom state:

```bash
ocuroot state set release.ocu.star/@/custom/approve 1
```

This will update the intent repo, triggering another workflow to complete the release.

## Configuration

There are three key pieces of configuration enabling this flow:

The [release.yml](https://github.com/ocuroot/gh-actions-example/blob/main/.github/workflows/release.yml) workflow file on
the `main` branch is triggered on pushes to this branch and will create new releases as the source changes. This powers step 1.

The [cascade.yml](https://github.com/ocuroot/gh-actions-example/blob/intent/.github/workflows/cascade.yml) workflow file on
the `intent` branch will pick up changes to intent and execute any required work to apply these intent changes. This powers step 2.

Finally, [repo.ocu.star](https://github.com/ocuroot/gh-actions-example/blob/main/repo.ocu.star) configures a remote URI for
the repo to use when fetching changes and using the default GitHub Token provided by Actions to allow pushes to the `intent` and `state` branches.

