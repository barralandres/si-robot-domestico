# Robot doméstico

El trabajo consiste en un conjunto de robots que realizan distintas actividades con el
fin de satisfacer las necesidades de su dueño. Se partirá de un código de un robot
doméstico funcional al que se le aplicarán múltiples modificaciones para aplicar nuevas
funcionalidades.

La actividad principal la realizará un robot mayordomo que satisfará la necesidad de
varios propietarios de beber cerveza. El robot irá a buscar la cerveza a un frigorífico y un
pincho para acompañar y regresará para entregar la cerveza y el pincho al dueño. Además
recogerá los platos de los pinchos cuando los propietarios hayan terminado y los llevará al
lavavajillas. Cuando el lavavajillas esté lleno lo encenderá y una vez terminado de lavar,
llevará los platos a la alacena.

A partir de esta necesidad surgen otras necesidades como la de comprar productos
para rellenar el frigorífico, limpiar el entorno de basura y vaciar la basura cuando esta se
llene. Cada una de estas actividades serán realizadas por distintos robots especializados
por petición del robot mayordomo. Además, los propietarios también pueden satisfacer
algunas de sus necesidades por su cuenta como la de coger una cerveza del frigorífico o
desechar la basura.

Los supermercados venderán sus productos y repondrán existencias solicitandoles a
un proveedor.

En definitiva, se establece un ecosistema de agentes distintos con diferentes
creencias y objetivos que trabajan de forma conjunta realizando distintas actividades.

## Agentes
El sistema se divide en varios agentes los cuales realizan, cada uno, una serie de
tareas distintas. La misión principal es satisfacer la necesidad de cada propietario de beber
cerveza y para ellos contamos con un conjunto de robots que se especializa cada uno en
una tarea distinta, tenemos un robot mayordomo y un conjunto de tres robots subordinados
al robot mayordomo con la misión de comprar más cerveza, limpiar el entorno y sacar la
basura. Además existen agentes supermercado y un proveedor para garantizar que siempre
haya existencias de los productos.

### rmayordomo
El robot mayordomo tiene el objetivo de llevarle cerveza al propietario cuando este se
la solicite. Cuando un propietario le pida una cerveza irá a la nevera y cogerá una cerveza y
un pincho para acompañar (Si no hay, los fabricará) y se lo llevará al propietario para que
los consuma.

El propietario le podrá solicitar que recoja su plato sucio y esté irá junto al propietario,
recogerá el plato y lo llevará al lavavajillas (cuando este esté lleno lo encenderá para lavar
los platos). Cuando los platos estén lavados los meterá en la alacena.

Cuando el robot mayordomo se encuentre en la nevera puede ver los productos que
se encuentren dentro: cuando esto suceda deberá evaluar si hay que comprar productos y
comprarlos si es necesario realizando un pedido al supermercado.

El robot mayordomo también es el encargado de controlar otros robots subordinados.
El robot estará pendiente de si el entorno está sucio, la papelera llena o si se ha realizado
una entrega por parte del supermercado. Si esto se da avisará a los robots limpiador,
basurero y de pedidos respectivamente.

### owner
Los propietarios tienen el objetivo de beber cerveza y para ello inicia una interacción
con el robot mayordomo para pedirle cerveza (anteriormente le habrá entregado el dinero
que tenga). El robot mayordomo le traerá cerveza y un pincho que consumirá poco a poco.
También puede darse que el propietario vaya a buscar cerveza a la nevera (No cogerá un
pincho) para beberla. Tras terminar una cerveza podrá tirarla en el entorno, llevarla a la
papelera para tirarla o pedirle al robot mayordomo que la recoja (Si ve la papelera llena
avisará de ello al robot mayordomo). Al terminar un pincho avisará al robot mayordomo para
que recoja el plato sucio.

El propietario puede sentirse aburrido cada cierto tiempo y cuando esto suceda
intercambiará mensajes con el robot mayordomo o le pedirá la hora.

### rlimpiador
Puede darse el caso de que el propietario tire latas por el entorno por lo que el robot
mayordomo le indicará al robot limpiador que las recoja y las tire en un cubo de basura.
También puede darse el caso de que el propietario no tire la lata sino que avise al robot
mayordomo de que tiene basura. En ese caso el robot mayordomo avisará al robot
limpiador de que vaya junto al propietario para recoger la basura y desecharla.

### rbasurero
Desechar la basura provocará que el cubo se llene. El robot limpiador así como el
propietario serán los encargados de avisar al robot mayordomo del estado del cubo cuando,
al abrir el cubo, hayan percibido la cantidad de basura en él. Con este aviso el robot
mayordomo puede pedirle al robot basurero que vacíe el cubo de basura.

### rpedidos
El robot mayordomo al tener notificación de la entrega de los productos por parte del
supermercado avisará al robot de pedidos, que tiene objetivo de reponer el producto, para
que reponga los productos en el frigorífico. Al terminar avisará al robot mayordomo.

### supermarket

Cuando el robot percibe que hay pocas existencias de cerveza (evitando que estas
lleguen a cero) solicita al supermercado la entrega del producto demandado. El
supermercado tiene el objetivo de entregar productos, una vez que los productos se hayan
entregado avisará al robot mayordomo.

Además el supermercado tendrá que reponer sus existencias para no quedarse sin
productos y satisfacer las solicitudes del robot mayordomo. Para reponer existencias se las
pedirá al proveedor que le enviará los productos que solicite si tiene existencias.
proveedor

El proveedor es el encargado de satisfacer las solicitudes de los supermercados que
pretenden reponer sus existencias. Este atenderá a las peticiones y tramitará los envíos a
los supermercados. Cuando se realice el envío se realizarán los pagos.

### lavavajillas
El lavavajillas únicamente lavará los platos cuando el robot mayordomo se lo indique.
