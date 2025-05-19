# VIM

## File interaction

Open or create new file:

```bash
vim deployment.yaml
```

You start in `NORMAL` mode. To enter `INSERT` mode press `i`. To go back to `NORMAL` mode press `Esc`.

Shortcuts to exit:

| Command | Action                                 |
| ------- | -------------------------------------- |
| `:2`    | Save changes                           |
| `:q`    | Exit without changes                   |
| `:wq`   | Save changes and exit                  |
| `:q!`   | Exit without changes and ditch changes |

## `NORMAL` Mode

---

You can navigate in `NORMAL` mode using arrow keys or `hjkl` keys.

```text
      ↑
      k
 ← h     l →
      j
      ↓
```

### Basic `NORMAL` mode shortcuts

| Shortcut      | Action                                                            |
| ------------- | ----------------------------------------------------------------- |
| `gg`          | Go to the beginning of the document                               |
| `G`           | Go to the end of document                                         |
| `Ctrl+F`      | Scroll down one page size                                         |
| `Ctrl+B`      | Scroll up one page size                                           |
| `/ + <text>`  | Search `<text>`                                                   |
| `n`           | Find next search occurrence                                       |
| `N`           | Find previous search occurrence                                   |
| `w`, `e`      | Go forward one word                                               |
| `b`, `ge`     | Go backwards one word                                             |
| `^`, `0`      | Go to the beginning of the line                                   |
| `$`           | Go to the end of the line                                         |
| `f + <char>`  | Go to the next `<char>` of the line                               |
| `F + <char>`  | Go to the previous `<char>` of the line                           |
| `dd`          | Deletes current line                                              |
| `dw`          | Deletes all from current position to the end of word              |
| `diw`         | Deletes a word                                                    |
| `D`           | Deletes all from current position to the end of line              |
| `>>`, `<<`    | Applies o remove one level indentation                            |
| `u`, `ctrl+R` | Undo and redo                                                     |
| `p`, `P`      | Paste to the next line or previous                                |
| `cc`          | Delete current line and enter `INSERT` mode                       |
| `cw`          | Delete from cursor to the end of the word and enter `INSERT` mode |
| `ciw`         | Delete a word and enters `INSERT` mode                            |
| `C`           | Delete line from cursor to the end and enters `INSERT` mode       |
| `O`, `Ctrl+O` | Add new line below or above cursor and enters `INSERT` mode       |
| `i`           | Enter `INSERT` mode at cursor position                            |
| `a`           | Move cursor to the next character and enter `INSERT` mode         |
| `I`           | Move cursor to the beginning of the line and enter `INSERT` mode  |
| `A`           | Move cursor to the end of the line and enter `INSERT` mode        |
| `v`           | Enter `VISUAL` mode from current position and start selection     |
| `V`           | Select the entire line                                            |
| `viw`         | Select current word                                               |
| `y`           | Copy current selection and return back to `NORMAL` mode           |
| `yy`          | Copy current line                                                 |
