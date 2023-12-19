$maxx = 30 #poziomy rozmiar planszy
$maxy = 10 #pionowy rozmiar planszy
$lifes = 60 #liczba zywych celli
$refresh = 10 #Liczba odswiezen tablicy w jednym okresie

def checkArgs()
    if ARGV.nil? then
        puts "No arguments"
    elsif ARGV.length == 3 then
        $maxx = ARGV[0].to_i # 1 argument - rozmiar X planszy
        $maxy = ARGV[1].to_i # 2 argument - rozmiar Y planszy
        $lifes = ARGV[2].to_i # 3 argument - liczba zywych komorek
    elsif ARGV.length == 1 then
        $lifes = ARGV[0].int_i # 1 argument - liczba zywych komorek
    elsif ARGV.length == 2 then
        $maxx = ARGV[0].to_i # 1 argument - rozmiar X planszy
        $maxy = ARGV[1].to_i # 2 argument - rozmiar Y planszy
    elsif ARGV.length == 4  then
        $maxx = ARGV[0].to_i # 1 argument - rozmiar X planszy
        $maxy = ARGV[1].to_i # 2 argument - rozmiar Y planszy
        $lifes = ARGV[2].to_i # 3 argument - liczba zywych komorek
        $refresh = ARGV[3].to_i # 4 argument - liczba odswiezen tablicy w jednym okresie
    end
end



def printTab(tab) #wypisanie tablicy w ramce
    my = tab.length
    mx = tab[0].length
    print "+"
    mx.times {
        print "-"
    }
    puts "+"
    my.times {|y|
        print "|"
        mx.times { |x|
            case tab[y][x]
            when 0
                print " "
            when 1
                print "X"
            end
        }
        puts "|"
    }
    print "+"
    mx.times {
        print "-"
    }
    puts "+"
end 

def prepareTab(tab, lifes) #przygotowanie tablicy - stworzenie w losowych miejscach zyjacych komorek
    lifes = (lifes < $maxx*$maxy) ? lifes : $maxx*$maxxy

    count = 0
    while count < lifes do
        x = rand($maxx)
        y = rand($maxy)
        if tab[y][x] == 0 then
            tab[y][x] = 1
            count += 1
        end
    end
end

def nextGen(tab) #tworzenie nowej tablicy do kolejnego ujecia
    maxx = tab[0].length
    maxy = tab.length
    changesTo1 = Array.new(0)
    changesTo0 = Array.new(0)
    maxy.times {|y|
        maxx.times {|x|
            if tab[y][x] == 1 and countNeighbours(tab, x, y) < 2 then
                changesTo0[changesTo0.length] = x.to_s + " " + y.to_s
            elsif tab[y][x] == 1 and countNeighbours(tab, x, y) > 3 then
                changesTo0[changesTo0.length] = x.to_s + " " + y.to_s
            elsif tab[y][x] == 0 and countNeighbours(tab, x, y) == 3 then
                changesTo1[changesTo1.length] = x.to_s + " " + y.to_s
            end
        }
    }

    while changesTo0.length > 0 do
        split = changesTo0[0].split
        tab[split[1].to_i][split[0].to_i] = 0
        changesTo0.delete_at(0)
    end

    while changesTo1.length > 0 do
        split = changesTo1[0].split
        tab[split[1].to_i][split[0].to_i] = 1
        changesTo1.delete_at(0)
    end

    
    
end

def countNeighbours(tab, x, y) #funkcja zwraca liczbe sasiadow - 
    maxx = tab[0].length
    maxy = tab.length
    n = 0
    if (x - 1) >= 0 then
        if tab[y][x-1] == 1 then
            n += 1
        end
    end
    if (y - 1) >= 0 then
        if tab[y-1][x] == 1 then
            n += 1
        end
    end
    if (x + 1) < maxx then
        if tab[y][x+1] == 1 then
            n += 1
        end
    end
    if (y + 1) < maxy then
        if tab[y+1][x] == 1 then
            n += 1
        end
    end
    if (x - 1) >= 0 and (y - 1) >= 0 then
        if tab[y-1][x-1] == 1 then
            n += 1
        end
    end
    if (x + 1) < maxx and (y - 1) >= 0 then
        if tab[y-1][x+1] == 1 then
            n += 1
        end
    end
    if (x + 1) < maxx and (y + 1) < maxy then
        if tab[y+1][x+1] == 1 then
            n += 1
        end
    end
    if (x - 1) >= 0 and (y + 1) < maxy then
        if tab[y+1][x-1] == 1 then
            n += 1
        end
    end
    return n
end

############################

checkArgs()

$tab = Array.new($maxy) { 
    Array.new($maxx) 
}

for y in 0 ... $maxy
    for x in 0 ... $maxx
        $tab[y][x] = 0
    end
end

prepareTab($tab, $lifes)
printTab($tab)

$input = 'a'
while ($input != 'q') do
    time = 0.4
    count = 0
    if $input == 'f' and time > 0.1 then
        time -= 0.1
    elsif $input == 's' then
        time += 0.1
    end
    while count < $refresh
        nextGen($tab)
        sleep(time)
        printTab($tab)
        count += 1
    end
    print "q - wyjscie\nf - przyspiesz odswiezanie\ns - zwolnij odswiezanie\nkazdy inny znak - kontynuuj\npodaj znak: "
    $input = STDIN.gets.chomp #uzywany jest STDIN, poniewaz bez tego przy podaniu argumentow do programu wyskakiwal blad
end
