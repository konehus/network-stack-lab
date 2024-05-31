#!/usr/bin/env bash
set -e

# Rewrite all commits to have author and committer "Henok Haile <konehus@gmail.com>"
# and distribute commit dates across Jan-Jun 2023, Nov-Dec 2023, and Jan 2024.

# Gather all commits (branches and tags) in chronological order
commits=( $(git rev-list --reverse --all) )
N=${#commits[@]}

# Define time windows
w1_start=$(date -d '2023-01-01 00:00:00 +0000' +%s)
w1_end=$(date -d '2023-06-30 23:59:59 +0000' +%s)
w2_start=$(date -d '2023-11-01 00:00:00 +0000' +%s)
w2_end=$(date -d '2023-12-31 23:59:59 +0000' +%s)
w3_start=$(date -d '2024-01-01 00:00:00 +0000' +%s)
w3_end=$(date -d '2024-01-31 23:59:59 +0000' +%s)

w1=$((w1_end - w1_start))
w2=$((w2_end - w2_start))
w3=$((w3_end - w3_start))

# Allocate commit counts proportionally: 6:2:1 for the three windows
N1=$(( (6*N + 4) / 9 ))
N2=$(( (2*N + 4) / 9 ))
N3=$(( N - N1 - N2 ))

# Build env-filter script
cat > env-filter.sh << 'EOF'
#!/usr/bin/env bash
case $GIT_COMMIT in
EOF

for i in "${!commits[@]}"; do
  sha=${commits[i]}
  if (( i < N1 )); then
    idx=$i; slots=$N1; start=$w1_start; dur=$w1
  elif (( i < N1 + N2 )); then
    idx=$((i - N1)); slots=$N2; start=$w2_start; dur=$w2
  else
    idx=$((i - N1 - N2)); slots=$N3; start=$w3_start; dur=$w3
  fi
  if (( slots > 1 )); then
    frac=$(awk -v idx=$idx -v S=$slots 'BEGIN{printf("%.9f", idx/(S-1));}')
  else
    frac=0
  fi
  offset=$(awk -v dur=$dur -v f=$frac 'BEGIN{printf("%.0f", dur*f);}')
  if (( offset < w1 )); then
    ts=$(( start + offset ))
  elif (( offset < w1 + w2 )); then
    ts=$(( w2_start + offset - w1 ))
  else
    ts=$(( w3_start + offset - w1 - w2 ))
  fi
  datestr=$(date -u -d @$ts +%Y-%m-%dT%H:%M:%SZ)
  echo "  $sha) newdate=$datestr ;;" >> env-filter.sh
done

cat >> env-filter.sh << 'EOF'
esac
export GIT_AUTHOR_NAME='Henok Haile'
export GIT_AUTHOR_EMAIL='konehus@gmail.com'
export GIT_COMMITTER_NAME='Henok Haile'
export GIT_COMMITTER_EMAIL='konehus@gmail.com'
export GIT_AUTHOR_DATE=$newdate
export GIT_COMMITTER_DATE=$newdate
EOF

chmod +x env-filter.sh

# Rewrite the history: update author/committer info, commit messages, and file contents
git filter-branch --force \
  --env-filter './env-filter.sh' \
  --msg-filter "sed 's/gotcp/network-stack-lab/g'" \
  --index-filter "git ls-files -z | xargs -0 sed -i 's/gotcp/network-stack-lab/g' && git add -u" \
  --tag-name-filter cat -- --branches --tags

# Cleanup
rm env-filter.sh
echo "History rewritten. All commits now attributed to Henok Haile <konehus@gmail.com> with redistributed dates."