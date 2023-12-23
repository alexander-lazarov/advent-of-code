const fs = require('node:fs');

// const filename = 'input-sample.txt'
const filename = 'input.txt'

const grid = fs.readFileSync(filename, 'utf8').split("\n").map((line)=>line.split(""))

const h = grid.length
const w = grid[0].length

const start = [0, 1]
const target = [h -1, grid[h-1].indexOf(".")]

let visited = new Set([start[0] * w + start[1]])
let max = 0

function longestPath(start) {
  const [x, y] = start
  if (x === target[0] && y === target[1]) {
    max = Math.max(max, visited.size - 1)
    return
  }

  let i = x - 1
  let j = y

  if (i >= 0 && i < h && j >= 0 && j < w && grid[i][j] !== "#" && !visited.has(i * w + j)) {
    visited.add(i * w + j);
    longestPath([i, j])
    visited.delete(i * w + j);
  }

  i = x + 1

  if (i >= 0 && i < h && j >= 0 && j < w && grid[i][j] !== "#" && !visited.has(i * w + j)) {
    visited.add(i * w + j);
    longestPath([i, j])
    visited.delete(i * w + j);
  }

  i = x
  j = y - 1

  if (i >= 0 && i < h && j >= 0 && j < w && grid[i][j] !== "#" && !visited.has(i * w + j)) {
    visited.add(i * w + j);
    longestPath([i, j])
    visited.delete(i * w + j);
  }

  j = y + 1

  if (i >= 0 && i < h && j >= 0 && j < w && grid[i][j] !== "#" && !visited.has(i * w + j)) {
    visited.add(i * w + j);
    longestPath([i, j])
    visited.delete(i * w + j);
  }
}
longestPath(start)
console.log(max)
