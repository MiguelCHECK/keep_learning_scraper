#!/bin/bash
set -e

cd /tmp/workshop_secure

git init
git add .
git commit -m "security: Add complete security configuration to workshop repo

Added security features:
- GitHub Actions security-check workflow
- CODEOWNERS file requiring owner approval
- SECURITY.md with contributor guidelines
- Pull Request template with security checklist

Workshop files:
- README.md: Complete workshop guide
- requirements.txt: Python dependencies  
- .gitignore: Protects credentials and output files

This ensures workshop participants cannot accidentally commit
secrets while maintaining a safe learning environment."

git remote add origin git@github.com:MiguelCHECK/keep_learning_scraper.git
git branch -M main
git push --force origin main

echo "✅ Successfully deployed secure workshop repo!"

