repeat
    line = os.read()
until line ~= ""
print(line)

for v = 0, 255, 1 do
    if(colors[v] ~= nil) then
        add_to_chat(v, "Color "..v..": "..colors[v])
    else
        add_to_chat(v, "Color "..v..": This is some random text to display the color.")
    end

    if op == "+" then
        r = a + b
        if line > MAXLINES then
            showpage()
            line = 0
        end

    elseif op == "-" then
        r = a - b
    elseif op == "*" then
        r = a*b
    elseif op == "/" then
        r = a/b
    else
        error("invalid operation")
    end
end
