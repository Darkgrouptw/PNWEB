var idIndex = -1;
function Node(name)
{
    this.id = ++idIndex;
    this.name = name;
};

Node.prototype.printInfo = function()
{
    console.log(this.id + " " + this.name);  
};