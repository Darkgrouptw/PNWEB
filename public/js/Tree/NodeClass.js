var idIndex = -1;
function Node(name)
{
    this.id = ++idIndex;
    this.name = name;
};

Node.prototype.printInfo()
{
    console.log(this.id + " " + this.name);  
};