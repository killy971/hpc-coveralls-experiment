JSON="{\"service_name\":\"travis-ci\", \"service_job_id\":\"$TRAVIS_JOB_ID\", \"source_files\":[{\"coverage\":[null,0,1,2],\"name\":\"file1.rb\",\"source\":\"line1\nline2\nline3\nline4\"}]}"
echo $JSON > coverage.json
curl -F json_file=@coverage.json https://coveralls.io/api/v1/jobs
