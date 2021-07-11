echo "Starting Init"
echo "Changing Permissions"
sudo chown -R $USER ../metapede

# npm install from assets folder
echo "Installing NPM mods"
cd ./assets
npm install
cd ..

# # install inotify tools
echo "Getting Tool for auto-reload"
sudo apt update
sudo apt-get install inotify-tools -y

# # setup first build
echo "Installing Dependencies"
mix deps.get

# #  this creates the DB, runs the migrations
echo "Making DB"
mix ecto.reset
