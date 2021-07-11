echo "Starting Init"
echo "Changing Permissions"
sudo chown -R $USER ./assets
# sudo chown -R $USER ../workspace

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
mix local.hex --force
sudo mix deps.get --force

# #  this creates the DB, runs the migrations
echo "Making DB"
sudo mix ecto.setup