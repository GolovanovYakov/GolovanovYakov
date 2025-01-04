import pandas  as pd
# Создаем датафрейм из исходного файла базы данных Match
match = pd.read_csv('Match.csv')

# Создаем две новые колонки home_win и away_win для результатов матчей cо значениями True и False
match['home_win'] = match['home_team_goal'] > match['away_team_goal']
match['away_win'] = match['away_team_goal'] > match['home_team_goal']
display(match.head())
display(match.shape)
# Создаем  словари для подсчета побед и поражений
wins = {}
losses = {}

# Обрабатываем результаты матчей
# Создаем переменные home_team_id и away_team_id, в которых будут перечисляться id команд
for index, row in match.iterrows():
    home_team_id = row['home_team_api_id']
    away_team_id = row['away_team_api_id']
    
# Подсчет побед
# Победа домашней команды:   
    if row['home_win']:
    
# Если home_win = True, значит выиграла домашняя команда, условие выполняется
        wins[home_team_id] = wins.get(home_team_id, 0) + 1
        losses[away_team_id] = losses.get(away_team_id, 0) + 1
    elif row['away_win']:
# Ключами в словаре wins являются идентификаторы команд (например, home_team_id), а значениями — количество побед соответствующих команд.
# home_team_id-это переменная, которая содержит идентификатор домашней команды, выигрывающей матч. Он используется в качестве ключа для доступа к значению в словаре wins.
# wins.get(home_team_id, 0): Это метод get словаря, который выдает значение, соответствующее ключу home_team_id из словаря wins. 
# Если такой ключ отсутствует, метод вернёт значение по умолчанию, которое в данном случае равно 0. 
# Если команда ещё не записывалась в словаре wins, то её стартовое количество побед должно быть нулевым.
# Так как команда выиграла, прибавляем +1, чтобы счетчик побед увеличивался.

# wins[home_team_id] =  Эта часть присваивает новое значение (текущее количество побед + 1) обратно в словарь  wins с ключом home_team_id.        
        
        
# Победа для гостевой команды
        wins[away_team_id] = wins.get(away_team_id, 0) + 1
        losses[home_team_id] = losses.get(home_team_id, 0) + 1

# Преобразуем в DataFrame 
results = pd.DataFrame({
    'team_api_id': list(set(wins.keys()).union(set(losses.keys()))),
# wins.keys(): Возвращает все ключи из словаря wins, которые представляют ID команд, выигравших матчи.
# losses.keys(): Возвращает все ключи из словаря losses, которые представляют ID команд, проигравших матчи.
# set(): Преобразует список ключей в множество, чтобы удалить дубликаты.
# union(): Объединяет два множества (выигрыши и проигрыши), чтобы получить все уникальные идентификаторы команд.
# Таким образом, результатом будет множество всех уникальных team_api_id, представляющих команды, которые либо выиграли, либо проиграли хотя бы один матч.
#list() Преобразует результат объединения множеств в список. Это позволяет использовать его для создания DataFrame.
   
    'wins': [wins.get(team_id, 0) for team_id in list(set(wins.keys()).union(set(losses.keys())))],
# Здесь создаётся новый список для столбца wins. Для каждого team_id в списке уникальных ID команд проверяется, есть ли этот ID в словаре wins.
# Если команда выигрывала, возвращает количество её побед, в противном случае возвращает 0. Таким образом, если команды нет в словаре wins, в этом поле будет указано 0.
    'losses': [losses.get(team_id, 0) for team_id in list(set(wins.keys()).union(set(losses.keys())))]
})
display(results) 
