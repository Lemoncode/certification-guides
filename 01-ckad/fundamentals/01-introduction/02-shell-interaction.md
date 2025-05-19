# Shell Interaction

## File System Navigation

You can use `cd` command following a path to move to that directory. If no argument is passed you'll move to your home directory.

Moving to an absolute path.

```bash
cd /var/log
```

Move to a relative path from the current directory.

```bash
cd deployments/production
```

Move to your home folder. You can also pass `~` argument.

```bash
cd
cd ~
```

## Inspecting files and folders

You can use `ls` command to see one or more folders' content. If no argument is passed it will list content from the current folder.

List content from the current folder. You can also pass `.` argument.

```bash
ls
```

List content from a different folder than current one.

``bash
ls /var/log
alternatives.log apt btmp dpkg.log faillog lastlog wtmp

| Flags | Action                                                                          |
| ----- | ------------------------------------------------------------------------------- |
| `-l`  | Displays more advanced information like owner, permissions, edit time, symlinks |
| `-a`  | Displays hidden files and folders                                               |

You can use `cat` command to print contents of a file to stdout.

```bash
cat /etc/services
```

You can use `head` command to print first 10 lines of a file to stdout.

```bash
head /etc/services
```

You can pass `-N` where `N` is a number to change how many lines you want to print.

```bash
head -20 /etc/services
```

You can use `more` similar to `cat` to display file contents but it will display by chunks based on screen size. To display next chunk press `Space`key.

```bash
more /etc/services
```

You can use `tail` similar to `head` to display last 10 lines of a file to stdout.

```bash
tail /etc/services
```

You can add `-N` flag where `N` is the number of lines you want to display from the end.

```bash
tail -20 /etc/services
```

You can use `less` command to open an interactive screen where you can navigate through the file contents. You can use arrow keys and `/` plus some term to search, similar to VIM. To close interactive screen press `q`.

```bash
less /etc/services
```

---

## Re execute commands

You can use arrow up `↑` and down `↓` keys to navigate to previously executed commands if you want to use them again.

You can press `Ctrl+R` and start writing a command to search in history commands with that pattern. Pressing `Ctrl+R` multiple times will search next occurrence.

- To execute a command press `Enter`.
- To edit that command press `Space`.

## Environment variables

Variables are prefixed with a `$` sign. To display the `USER` variable content use:

```bash
echo $USER
```

To create a variable set the variable name followed by `=` and the value:

```bash
MY_NAME=Santi
```

Double quotes interpolate variable values. Single quotes don't:

```bash
echo "Hello, $MY_NAME" # Results in "Hello, Santi"
echo 'Hello, $MY_NAME' # Results in "Hello, $MY_NAME"
```

You can use `env` command to display all environment variables and their values.

```bash
env
```

## Basic commands

You can use `touch` command to create a file or change its modification time.

```bash
touch projects/pod.yaml
```

You can use `sleep` command to suspend execution for an interval of time. It receives a number as argument (seconds) to wait. You can suffix the number with `s`, `m`, `h`, `d`

Bloquea la terminal durante una cantidad de tiempo. Podemos especificar un número en segundos o añadir el sufigo `s`, `m`, `h`, `d`.

```bash
sleep 10 # waits 10 seconds
sleep 20s # waits 20 seconds
sleep 3m # waits 3 minutes
sleep 1h # waits 1 hour
sleep 5d # waits 5 days
sleep infinity # waits forever
```

You can use `grep` command to display lines in files that matches a patten.

```bash
grep Debian /etc/os-release
```

| Flag     | Action                                                          |
| -------- | --------------------------------------------------------------- |
| `-i`     | Applies case insensitive                                        |
| `-v`     | Inverts the search, it will find lines NOT matching the pattern |
| `-B <n>` | Also display `n` lines before the occurrence.                   |
| `-A <n>` | Also display `n` lines after the occurrence.                    |
| `-n`     | Also display `n` lines before and after the occurrence.         |

You can use `mkdir` to create a folder.

```bash
mkdir /tmp/backups
```

Use `-p` flag to recursively create folders

```bash
mkdir -p backups/2025-05-05/dotfiles/vim
```

You can use `cp` to copy a file to a destination. If destination exists and it's a file it will replace its content. If the destination exists and it's a folder it will create a file in that folder. You can use a different name for the destination file but the destination folder must exist.

```bash
cp ~/.vimrc backups/vim/vimrc
```

You can use `-r` flag to recursively copy folders. In this case source file will be a folder and destination will also be a folder.

You can use `mv` command to move a file or folder to a different location. If the source is a folder or a file and destination is a folder it will move source into destination. If the source is a file and destination is also a file it will replace destination content.

```bash
mv backups/vim/vimrc ~/.vimrc
```

You can use `rm` command to delete a files (and folders with `-r` flag).

```bash
rm pod.yaml
rm -r backups/
```

You can use `curl` command to make requests service (mostly a web server).

```bash
curl https://www.google.es
```

| Flag            | Action                                                                     |
| --------------- | -------------------------------------------------------------------------- |
| `-L`            | Follow redirection in case server responds with a 30X redirection          |
| `-m <n>`        | Times out after `n` seconds                                                |
| `-s`            | Hide progress                                                              |
| `-I`            | Show headers                                                               |
| `-o <filename>` | Writes response to `filename` instead of stdout                            |
| `-H <header>`   | Applies a request header (e.g. `-H "Content-Type: application/json"`)      |
| `-X <VERB>`     | Changes request type where `VERB` can be `GET`, `POST`, `HEAD`, `PUT`, etc |

You can use `wget` as `curl` to make requests to a service. It will automatically follow redirection and saves the response in a file.

```bash
wget https://www.google.es
```

| Flag            | Acción                      |
| --------------- | --------------------------- |
| `-T <n>`        | Times out after `n` seconds |
| `-q`            | Hide download status        |
| `-I`            | Show headers                |
| `-O <filename>` | Writes output in `filename` |
| `-O -`          | Writes output to stdout     |

---

## Pipelines `|`

You can use `|` to combine multiple commands. The output of each command in the pipeline is connected via a pipe `|` to the input of the next command. That is, each command reads the previous command's output.

```bash
kubectl config view | grep server
kubectl get all | grep -v "^kube"
echo "Hello world" | base64 | base64 -d
kubectl config view | wc -l
```

## Redirection

### STDOUT

Before a command is executed, its input and output may be redirected using a special notation interpreted by the shell. Redirection allows commands' file handles to be duplicated, opened, closed, made to refer to different files, and can change the files the command reads from and writes to.

- To redirect standard output `STDOUT` to a file and replace its contents use `> filename`. Operator `>` is same as `1>`
- To redirect standard output `STDOUT` to a file and appends new content use `>> filename`. Operator `>>` is same as `1>>`
- To redirect standard error `STDERR` to a file and appends new content use `>> filename`.

```bash
echo "Hello world" > file.txt
echo "Second line" >> file.txt
kubectl config view > config.yaml
ls nonexistent 2> errors.log
grep -R "Server" /etc 2>/dev/null
```

## Shell Scripting

## Conditional constructs

You can use `if` construct to conditionally evaluate one or more commands.

Create `script.sh` file with next content and add execution permissions with `chmod +x script.sh`.

```bash
#!/bin/sh

if [ -f ./some-file.txt ]; then
  echo "This file exists"
else
  echo "This file does not exist"
fi
```

Execute script with `./script.sh`. Create `./some-file.txt` to modify its behavior.

You can use multiple branches

```bash
#!/bin/sh

FOO="$1" # Declare variable `FOO` with first argument as value
if [ "$FOO" = "foo" ]; then
  echo "FOO is foo"
elif [ "$FOO" = "bar" ]; then
  echo "FOO is bar"
elif [ -z "$FOO" ]; then
  echo "FOO is nothing"
else
  echo "FOO is other thing"
fi
```

Example executions:

```bash
./script.sh
./script.sh foo
./script.sh bar
./script.sh baz
```

You can conditionally execute code based on success/failure command execution:

```bash
#!/bin/sh

if grep "fedora" /etc/os-release; then
  echo "It's Fedora based"
fi

if ! grep "fedora" /etc/os-release; then
  echo "Definitively it is not Fedora based"
fi
```

```bash
./script.sh
```

## Loop constructs

You can use `for` loop to iterate over a list of elements

```bash
#!/bin/sh

for i in $(seq 1 10); do
  echo $i
done
```

```bash
./script.sh
```

You can use `while` loop to iterate while condition is met.

```bash
#!/bin/sh

i=1
while [ $i -le 5 ]; do
  echo $i
  i=$((i + 1))
done

while true; do
  sleep 1
  echo "Sleeping 1 second;
done
```

```bash
./script.sh
```

You can use `until` loop to execute code while condition is not met.

```bash
#!/bin/sh

until [ -f /tmp/file.txt ]; do
  echo "Waiting file to exist"
  sleep 5
done
```

```bash
./script.sh
```

Create `/tmp/file.txt` in another terminal to exit loop.
