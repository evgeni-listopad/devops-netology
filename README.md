# devops-netology
This is the README-file for the first hometask project. The line was added according to the list of tasks.
This line was added according to my own decision for checking how the commands "git diff" and "git diff --staged" work.

Description for the .gitignore:

**/.terraform/*
- Будут игнорироваться любые файлы в каталоге ".terraform", вне зависимости от того, где бы в файловой системе этот каталог не находился.

*.tfstate
- Будут игнорироваться любые файлы, в начале имени которых содержатся любые символы в любом количестве, а в конце обязательно присутствует подстрока ".tfstate"

*.tfstate.*
- Будут игнорироваться любые файлы, в имени которых содержится подстрока ".tfstate."

crash.log
- Будет игнорироваться файл crash.log

crash.*.log
- Будут игнорироваться любые файлы, в начале имени которых содержится подстрока "crash.", а в конце имени - подстрока ".log"

*.tfvars
- Будут игнорироваться любые файлы, в начале имени которых содержатся любые символы в любом количестве, а в конце обязательно присутствует подстрока ".tfvars"

*.tfvars.json
- Будут игнорироваться любые файлы, в начале имени которых содержатся любые символы в любом количестве, а в конце обязательно присутствует подстрока ".tfvars.json"

override.tf
- Будет игнорироваться файл override.tf

override.tf.json
- Будет игнорироваться файл override.tf.json

*_override.tf
- Будут игнорироваться любые файлы, в начале имени которых содержатся любые символы в любом количестве, а в конце обязательно присутствует подстрока "_override.tf"

*_override.tf.json
- Будут игнорироваться любые файлы, в начале имени которых содержатся любые символы в любом количестве, а в конце обязательно присутствует подстрока "_override.tf.json"

.terraformrc
- Будет игнорироваться файл .terraformrc

terraform.rc
- Будет игнорироваться файл terraform.rc

This line was added according to the task about creating a new branch with the name "fix".

