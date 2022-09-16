set -ue

projectnames="$1"
bucket_url="$2"

echo "projectnames: $projectnames"
echo "bucket_url: $bucket_url"

Field_Separator=$IFS
# set comma as internal field separator for the string list
IFS=,
for p in $projectnames
do
  echo "Getting DNS zones from project: $p"
  gcloud dns managed-zones list --format='csv(name)' --project $p | tr -d '\015' | tail -n +2 |
  while read -r i;
  do
    echo "Running backup on zone:"$i
    #gcloud dns record-sets list --zone=$i --project $p
    gcloud dns record-sets export zonedump-$i.tmp --zone-file-format --project $p --zone=$i
    echo "Copying to Storage"
    gsutil cp zonedump-$i.tmp $bucket_url/$p
    echo "Done!"
  done
  echo "Backup of DNS zone on project: $p is done!"
done