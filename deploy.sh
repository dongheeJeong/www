#!/bin/sh

set -e
set -x

bucket="dongheejeong.xyz"


# --size-only 의 부작용이 있을 수 있는데, 거의 없을 것 같으니 일단은 쓴다.
# 쓰지 않으면, last modified가 바뀌어도 sync 대상이므로 실질적인 content가 바뀌지 않아도 data transfer가 일어나는 문제가 있다.
aws s3 sync build s3://${bucket} --delete --size-only
aws s3 ls s3://${bucket} --recursive

