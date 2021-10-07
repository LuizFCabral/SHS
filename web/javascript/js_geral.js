var index;

//Seta todos os campos para não necessários (só serve de suporte)
function resetarCampos() {
    $('#idCod').attr('required', false);
    $('#idNome').attr('required', false);
    $('#idCPF').attr('required', false);
    $('#idDataNasc').attr('required', false);
    $('#idCidade').attr('required', false);
    $('idQtdeDose').attr('required', true);
}

//Quando um botão de operação do CRUD é clicado, define quais os campos necessários
function definir(i)
{
    index = i;

    switch (index) {
        case 0:
            resetarCampos();

            $('#idNome').attr('required', true);
            $('#idCPF').attr('required', true);
            $('#idDataNasc').attr('required', true);
            $('#idCidade').attr('required', true);
            $('idQtdeDose').attr('required', true);
            break;

        case 1:
            resetarCampos();

            $('#idCod').attr('required', true);
            $('#idNome').attr('required', true);
            $('#idCPF').attr('required', true);
            $('#idDataNasc').attr('required', true);
            $('#idCidade').attr('required', true);
            $('idQtdeDose').attr('required', true);
            break;

        case 2:
            resetarCampos();

            $('#idCod').attr('required', true);
            break;

        case 3:
            resetarCampos();
            break;

        default:
            break;
    }
}

//roda no envio de um form para testar se o código é válido
function verificar(j)
{
    if (index === 1 || index === 2)
    {
        cod = document.getElementById("idCod").value.toString();
        if (cod.length === 0 || cod.includes('.') || cod.includes('-') || isNaN(cod) || parseInt(cod) == 0)
        {
            if (j == 1)
                j = "um usuário";
            if (j == 2)
                j = "uma vacina";
            alert("Para alterar ou remover " + j + ", informe o seu código. O código é um número inteiro positivo.");
            return false;
        }
    }
    return true;
}

//algoritmo para validação do CPF
/*function validaCPF() {
    var CPF;
    var soma1, soma2, resto1, resto2;
    CPF = $("#idCPF").val();
    //retira as eventuais pontuações que o campo pode ter
    CPF = CPF.replace(".", "");
    CPF = CPF.replace("-", "");
    
    //verifica se o campo é valido em um nível um pouco mais geral
    if (isNaN(CPF)||
        CPF.length !== 11 ||
        CPF === "00000000000" ||
        CPF === "11111111111" ||
        CPF === "22222222222" ||
        CPF === "33333333333" ||
        CPF === "44444444444" ||
        CPF === "55555555555" ||
        CPF === "66666666666" ||
        CPF === "77777777777" ||
        CPF === "88888888888" ||
        CPF === "99999999999") {
        alert("O CPF digitado está invalido");
        $("#idCPF").val("");
        //$("#idCPF").focus();
        $("#idCPF").animate({backgroundColor: '#faa'}, 'slow');
    }
    else{
        //soma1:
        soma1+= (parseInt(CPF.substring(0,1)))*10;
        soma1+= (parseInt(CPF.substring(1,1)))*9;
        soma1+= (parseInt(CPF.substring(2,1)))*8;
        soma1+= (parseInt(CPF.substring(3,1)))*7;
        soma1+= (parseInt(CPF.substring(4,1)))*6;
        soma1+= (parseInt(CPF.substring(5,1)))*5;
        soma1+= (parseInt(CPF.substring(6,1)))*4;
        soma1+= (parseInt(CPF.substring(7,1)))*3;
        soma1+= (parseInt(CPF.substring(8,1)))*2;
        
        //soma2:
        soma2+= (parseInt(CPF.substring(0,1)))*11;
        soma2+= (parseInt(CPF.substring(1,1)))*10;
        soma2+= (parseInt(CPF.substring(2,1)))*9;
        soma2+= (parseInt(CPF.substring(3,1)))*8;
        soma2+= (parseInt(CPF.substring(4,1)))*7;
        soma2+= (parseInt(CPF.substring(5,1)))*6;
        soma2+= (parseInt(CPF.substring(6,1)))*5;
        soma2+= (parseInt(CPF.substring(7,1)))*4;
        soma2+= (parseInt(CPF.substring(8,1)))*3;
        soma2+= (parseInt(CPF.substring(9,1)))*2;
        let nun1 = parseInt(CPF.substring(8,1));
        let nun2 = parseInt(CPF.substring(9,1));
        

        //atribuição dos restos
        resto1 = (soma1 * 10) % 11;
        resto2 = (soma2 *10) % 11;
        if ((resto1 === 10) || (resto1 === 11)) {
            resto1 = 0;
        }
        if ((resto2 === 10) || (resto2 === 11)) {
            resto2 = 0;
        }
        //aqui é onde ocorre efetivamente a validação do CPF
        if ((resto1 === nun1) && (resto2 === nun2)) {
            alert("CPF válido!");
        }
        else {
            alert("O CPF digitado está invalido");
            $("#idCPF").val("");
            //$("#idCPF").focus();
            $("#idCPF").animate({backgroundColor: '#faa'}, 'slow');
        }
    }
}*/