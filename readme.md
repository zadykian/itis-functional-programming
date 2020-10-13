# UltimateTicTacToe

Данная игра представляет собой продвинутый вариант крестиков-ноликов. Игровое поле, именуемое глобальным, так же состоит из девяти ячеек (квадрат 3х3), но особенность в том, что в каждой ячейке содержится ещё одно поле (уже локальное), которое выглядит аналогично полю в классической игре.

Играют два игрока. Первый игрок [X] делает ход, заняв любую из 81-ой ячейки. Занятая им позиция в локальном поле определяет одно из девяти локальных полей, ячейку в котором должен будет заполнить второй игрок [O] на следующем ходе.

В рамках локального поля действуют правила классической игры. Как только один из двух игроков выстаивает линию в 3 ячейки, локальное поле становится недоступно для будущих ходов и присваивается данному игроку.

Если для игрока ходом оппонента определяется полностью заполненное локальное поле или поле, захваченное одним из игроков, игрок может выбрать для хода любую доступную ячейку на всем глобальном поле.

Цель игры - выстроить на глобальном поле линию из трёх захваченных локальных полей.