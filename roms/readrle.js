const Jimp = require('jimp');
const path = require('path');
const fs = require('fs');

async function main() {
	const rle = fs.readFileSync('otcametapixel.rle', {encoding: 'utf-8', });
	const lines = rle.split(/\r?\n/);
	
	const width = 2058;
	const height = 2058;
	const white = 0xFFFFFFFF;
	
	let img = await new Jimp(width, height, 'black');
	
	let str = ""; // one long string for the RLE thingy
	
	// buffer the rle
	lines.forEach(line => {
		if (!line.startsWith('#')) {
			str += line;
		}
	});
	
	let i = 0;
	let x = 0, y = 0;
	while (i < str.length) {
		// Check if we're looking at a number or a letter
		let j = 0;
		while (!isNaN(str[i + j])) {
			j++;
		}
		let numIterations = 1;
		// if we're looking at a number (default 1)
		if (j > 0) {
			numIterations = parseInt(str.substring(i, i + j));
		}
		let code = str.substring(i + j, i + j + 1);
		
		// end of line
		if (code == '$') {
			x = 0;
			y++;
		}
		// dead cell
		else if (code == 'b') {
			x += numIterations; // we don't need to modify pixels
		}
		// alive cell
		else if (code == 'o') {
			// loop through the pixels and set to white
			for (let k = 0; k < numIterations; k++) {
				img.setPixelColor(white, x, y);
				x++;
			}
		}
		
		i += j + 1;
		// i = 999999999;
	}
	
	
	await img.writeAsync('./output.png', Jimp.MIME_PNG);
}

main();