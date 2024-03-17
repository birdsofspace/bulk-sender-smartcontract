const { exec } = require('child_process');
const fs = require('fs');

// Definisikan perintah CLI yang ingin dijalankan
const command = 'slither "E:/BOS/smartcontract/bulk-sender-smartcontract/contracts/ERC20BulkSender.sol" --print human-summary,modifiers,function-summary';

// Eksekusi perintah CLI
exec(command, (error, stdout, stderr) => {
  if (error) {
    console.error(`Error executing command: ${error}`);
    return;
  }

  // Tulis output ke dalam file
  fs.writeFile('output.md', stdout, (err) => {
    if (err) {
      console.error(`Error writing to file: ${err}`);
      return;
    }
    console.log('Output telah disimpan dalam file output.md');
  });
});
