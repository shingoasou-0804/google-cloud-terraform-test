import os

from google.cloud import storage


storage_client = storage.Client.from_service_account_json("terraform_test_service_account_key.json")


def backup_objects_between_buckets():
    source_bucket_name = "test-oshin-drone-backup"
    source_blob_name = "fs.csv"
    destination_bucket_name = "test-oshin-drone-destination-bucket"
    destination_blob_name = "destination_fs.csv"

    # source_bucket = storage_client.bucket(source_bucket_name)
    # source_blob = source_bucket.blob(source_blob_name)
    # destination_bucket = storage_client.bucket(destination_bucket_name)
    # destination_generation_match_precondition = 0

    # blob_copy = source_bucket.copy_blob(
    #     source_blob,
    #     destination_bucket,
    #     destination_blob_name,
    #     if_generation_match=destination_generation_match_precondition
    # )

    # return f"Blob {source_blob_name} in bucket {source_bucket.name} copied to blob {blob_copy.name} in bucket {destination_bucket.name}."
    print("test exec method")


if __name__ == "__main__":
    backup_objects_between_buckets()
