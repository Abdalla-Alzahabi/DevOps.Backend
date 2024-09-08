# Task 3: Resolve a Merge Conflict

## Resolving Merge Conflicts in Dockerfile

### Objective

To resolve conflicts in the Dockerfile within the DevOps.Backend repository and ensure the code integrates correctly.

## Steps to Resolve Merge Conflicts

1. i will clone the Repository First, 

```bash
git clone https://abdallazahabi@dev.azure.com/abdallazahabi/abdalla-zahabi/_git/DevOps.Backend
cd DevOps.Backend
```

2. then i will fetch and checkout Branches Fetch the latest updates from the remote repository and checkout the branches you need to merge:

```bash
git fetch origin
git checkout main
git pull origin main
```

3. then identify the Conflict Switch to the branch with the conflicting changes (**feature-branch**):

```bash
git checkout feature-branch
git pull origin feature-branch
```

i will try to merge the **main** branch into **feature-branch** to see the conflict:

```bash
git merge main
```

Git will identify conflicts and stop the merge process. Conflicted files will be marked


4. then resolve the Conflict in Dockerfile Open the Dockerfile to manually resolve the conflict. Conflicted sections will look like this:

```diff
<<<<<<< HEAD
# Existing content in the main branch
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
=======
# Conflicting content in the feature-branch
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8082
>>>>>>> feature-branch
```

 and resolve the conflict by editing the file to integrate the changes. Ensure the final Dockerfile meets the requirements of both branches and maintains functionality. For instance:


```Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
```

then Remove conflict markers (<<<<<<<, =======, >>>>>>>) and save the file.


5. and test the Dockerfile Build and test the Docker image to ensure the Dockerfile works as expected:

```bash
docker build -t devops.testapp .
```

Run the Docker container to validate:

```bash
docker run -p 8080:8080 -p 8081:8081 devops.testapp
```

6. mark the Conflict as Resolved Once you're satisfied with the resolution, add the resolved Dockerfile:

```bash
git add Dockerfile
```

Continue the merge process:

```bash
git commit -m "Resolved merge conflict in Dockerfile"
```

7. push Changes Push the resolved changes to the remote repository:

```bash
git push origin feature-branch
```

8. finally create a pull request to merge **feature-branch** into **main** on your remote repository.
