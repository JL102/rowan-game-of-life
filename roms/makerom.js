const Jimp = require('jimp');
const path = require('path');
const fs = require('fs');

async function main() {
	
	if (!process.argv[2]) {
		console.log('Please enter a file path, e.g. node ./makerom.js ./image.png');
		process.exit(1);
	}
	
	// Get the file path to the image which we will read
	const imagePath = path.join(__dirname, process.argv[2]);
	if (!fs.existsSync(imagePath)) {
		console.log('File does not exist: ' + imagePath);
		process.exit(1);
	}
	
	const image = await Jimp.read(imagePath);
	const width = image.bitmap.width;
	const height = image.bitmap.height;
	
	// Pixels ABOVE the threshold will be treated as ALIVE
	const THRESHOLD = .5 * 255 * 3;
	let liveCells = [];
	
	image.scan(0, 0, width, height, function(x, y, idx) {
		// x, y is the position of this pixel on the image
		// idx is the position start position of this rgba tuple in the bitmap Buffer
		// this is the image
	   
		var red = this.bitmap.data[idx + 0];
		var green = this.bitmap.data[idx + 1];
		var blue = this.bitmap.data[idx + 2];
		
		if (red + green + blue > THRESHOLD) {
			liveCells.push([x, y]);
		}
	});
	
	let output = ''; // Output VHDL code
	for (let xy of liveCells) {
		output += `start_as(${xy[0]}, ${xy[1]}) <= '1';\n`
	}
	console.log(output);
	fs.writeFileSync(path.resolve('./output_code.txt'), output, {encoding: 'utf-8'});
	console.log('Done!');
}

main();