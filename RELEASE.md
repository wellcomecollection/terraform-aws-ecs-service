RELEASE_TYPE: patch

Make the logging container non-essential to prevent deployment issues where logging container cannot start (e.g. unavailable secrets)
