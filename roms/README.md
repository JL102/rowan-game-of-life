## ROM creator
Requires node.js: https://nodejs.org/en/

To run:
1. `npm install`
1. Create a bitmap image of the desired width and height. Black pixels are interpreted as dead, and white pixels are interpreted as alive.
1. `node ./makerom.js <path to image>`
1. The VHDL code will be both logged to the console and output to output_code.txt