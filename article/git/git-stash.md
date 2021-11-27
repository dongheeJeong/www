---
title: "Git stash"
date: "2021-11-23"
---


git-stash 에 대해 알아보자. man 페이지에서 주요한 내용을 정리한다.



## Description

`git statsh`는 working directory와 index의 현재 상태를 저장(record)하고자 할 때 사용한다. 이 명령은 로컬 변경을 저장하고 working directory를 `HEAD`로 되돌린다. 이 명령으로 저장된(stashed away) 변경 목록은 `git stash list` 로 조회되고 `git stash show`로 상세 조회가 된다. 그리고 `git stash apply`로 복구된다. 인자없는 `git stash` 호출은 `git stash push`와 동일하다. 


## Commands

* `git stash push` - stash 생성
* `git stash list` - stash list 조회
* `git stash show <stash>` - stash 상세 조회
* `git stash apply` - 생성했던 stash를 원복한다. 해당 stash는 삭제되지 않는다.
* `git stash pop <stash>` - 생성했던 stash를 원복한다. 해당 stash가 삭제된다. 다만, confilct 발생 시 삭제되지 않으며, `git stash drop`으로 삭제해줘야한다.
* `git stash drop <stash>` - 생성했던 stash를 삭제한다.
* `git stash branch <branchname> <stash>` - 브랜치를 생성하면서 `stash push` 당시의 HEAD commit 기준 `stash apply` 한다. 이것은 `stash push` 후 많은 변경이 이루어져 `stash apply`시 confilct가 발생할 때 유용하다.
