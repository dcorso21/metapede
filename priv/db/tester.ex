alias Metapede.Db.Schemas.Project

ps = Project.get_all()

Project.load(Enum.at(ps, 0))
|> IO.inspect()
