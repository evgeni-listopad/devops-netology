# devops-netology
#Домашнее задание к занятию «2.4. Инструменты Git»

1) Полный хеш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545

комментарий коммита: Update CHANGELOG.md

примененная команда: git show aefea

------------------------------------------------------

2) Коммит соответствует тегу: v0.12.23

примененные команды: "git show 85024d3" или можно "git log 85024d3" 

------------------------------------------------------

3) У коммита b8d720 два родителя (это merge-коммит). Их краткие хеш-значения: 56cd7859e 9ea88f22f.

Их полные хеш-значения: 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

примененные команды: "git show b8d720" или "git log --oneline --graph b8d720" (для получения кратких хеш-значений),

"git log --graph b8d720" (для получения полных хеш-значений).

------------------------------------------------------

4) Полные хеши и комментарии коммитов:

b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links

3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md

6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable

5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location

06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md

d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows

4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md

dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md

225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

примененная команда: "git log --pretty=oneline  v0.12.23..v0.12.24" (для полных хешей) или

"git log --oneline  v0.12.23..v0.12.24" (для кратких хешей)

------------------------------------------------------

5) Хеш искомого коммита: 8c928e835 (краткий) или 8c928e83589d90a031f811fae52a81be7153e82f (полный)

примененная команда: git log --oneline  -S 'func providerSource('

или для вывода полного хеша: git log --pretty=oneline  -S 'func providerSource('

------------------------------------------------------

6) Искомые коммиты:

78b122055 Remove config.go and update things using its aliases

52dbf9483 keep .terraform.d/plugins for discovery

41ab0aef7 Add missing OS_ARCH dir to global plugin paths

66ebff90c move some more plugin search path logic to command

8364383c3 Push plugin discovery down into command package

примененные команды: 

git grep -p globalPluginDirs

- было установлено, что имя функции встречается в трех файлах: commands.go, internal/command/cliconfig/config_unix.go, plugins.go.

- для каждого из них была применена команда git log --oneline -L , а именно:

git log --oneline -L :globalPluginDirs:commands.go  (для файла commands.go требуемых коммитов не было)

git log --oneline -L :globalPluginDirs:internal/command/cliconfig/config_unix.go (для файла internal/command/cliconfig/config_unix.go требуемых коммитов не было)

git log --oneline -L:globalPluginDirs:plugins.go (для файла plugins.go было пять коммитов, краткие хеши и комментарии к которым приведены выше)

------------------------------------------------------

7) Author: Martin Atkins <mart@degeneration.co.uk>

Информация из коммита 5ac311e2a91e381e2f52234668b49ba670aa0fe5

примененная команда: git log -S 'func synchronizedWriters('

и был выбран самый старый коммит.

