alias loc="find . -name '*.py' -type f -print | grep -v './venv/' | xargs wc -l"