// create a gith server on port 9001
var gith = require('gith').create( 9001 )
  , cmd = 'sh deploy.sh'
  , repo
  , opts;

// Repository options
repo = {
  repo: 'sanosom/webhook-deploy',
  branch: 'master'
};

// Child process options
opts = {
  // Directory
  cwd: '/home/ubuntu/webhook-deploy'
};

gith( repo ).on('all', function (payload){
  var exec = require('child_process').exec
    , puts;

  puts = function (error, stdout, stderr){
    console.log('Error: ', error);
    console.log('Stdout: ', stdout);
    console.log('Stderr: ', stderr);
  }

  exec(cmd, opts, puts);
});
