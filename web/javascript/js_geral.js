var index;

//Seta todos os campos para não necessários (só serve de suporte)
function resetarCampos() {
    $('#idCod').attr('required', false);
    $('#idNome').attr('required', false);
    $('#idCPF').attr('required', false);
    $('#idDataNasc').attr('required', false);
    $('#idCidade').attr('required', false);
    $('tipo_user').attr('required', true);
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
            $('tipo_user').attr('required', true);
            $('idQtdeDose').attr('required', true);
            break;

        case 1:
            resetarCampos();

            $('#idCod').attr('required', true);
            $('#idNome').attr('required', true);
            $('#idCPF').attr('required', true);
            $('#idDataNasc').attr('required', true);
            $('#idCidade').attr('required', true);
            $('tipo_user').attr('required', true);
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
function verificar()
{
    if (index === 1 || index === 2)
    {
        cod = document.getElementById("idCod").value.toString();
        if (cod.length === 0 || cod.includes('.') || cod.includes('-') || isNaN(cod))
        {
            alert("Para alterar ou remover um usuário, informe o seu código. O código é um número inteiro positivo.");
            return false;
        }
    }
    return true;
}