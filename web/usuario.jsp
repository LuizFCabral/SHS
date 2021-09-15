<%-- 
    Document   : usuario
    Created on : 09/09/2021, 11:31:16
    Author     : Vinicius
    create table usuario(
        codigo serial primary key,
        cpf varchar(14),
        nome varchar (40),
        data_nascimento date,
        cidade varchar(30)
    );
--%>

<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Banco"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CRUD Usuário</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            var index;
            
            function resetarCampos(){
                $('#idCod').attr('required', false);
                $('#idNome').attr('required', false);
                $('#idCPF').attr('required', false);
                $('#idDataNasc').attr('required', false);
                $('#idCidade').attr('required', false);
            }
            
            function definir(i)
            {
                index = i;
                switch(index){
                    case 0:
                        resetarCampos();
                        
                        $('#idNome').attr('required', true);
                        $('#idCPF').attr('required', true);
                        $('#idDataNasc').attr('required', true);
                        $('#idCidade').attr('required', true);
                        break;
                        
                    case 1:
                        resetarCampos();
                        
                        $('#idCod').attr('required', true);
                        $('#idNome').attr('required', true);
                        $('#idCPF').attr('required', true);
                        $('#idDataNasc').attr('required', true);
                        $('#idCidade').attr('required', true);
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
            function verificar()
            {
                if(index == 1 || index == 2)
                {
                    cod = Document.getElementById("idCod").value.toString();
                    if(cod.length == 0 || cod.includes('.') || cod.includes('-') || isNaN(cod))
                    {
                        alert("Para alterar ou remover um usuário, informe o seu código. O código é um número inteiro positivo.");
                        return false;
                    }
                }
                return true;
            }
        </script>
        
    </head>
    <body>
        <%
            Usuario obj;
            String b;
            UsuarioJpaController dao;
            Banco bb;
            try
            {
                if(request.getParameter("b1") == null)
                {
                    %>
                    <form action="usuario.jsp" method="post" onsubmit="return verificar()">
                            Código: <input type="text" name="txtCod" id="idCod"/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome"/> <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF"/> <br/>
                            Data de nascimento: <input type="text" name="txtDataNasc" id="idDataNasc"/> <br/>
                            Cidade: <input type="text" name="txtCidade" id="idCidade"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
                    <%
                }
            %><%
                else
                {
                    bb = new Banco();
                    dao = new UsuarioJpaController(Banco.conexao);
                    b = request.getParameter("b1");
                    Date dataNasc;
                    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                    int cod;
                    switch(b)
                    {
                        case "Cadastrar":
                            obj = new Usuario();
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(request.getParameter("txtCPF"));
                            dataNasc = Date.valueOf(request.getParameter("txtDataNasc"));
                            dataNasc = Date.valueOf(df.format(dataNasc));
                            obj.setDataNascimento(dataNasc);
                            obj.setCidade(request.getParameter("txtCidade"));
                            dao.create(obj);
                            %><h1>Usuário de <%=obj.getNome()%> cadastrado com sucesso. Código: <%=obj.getCodigo()%></h1><%
                            break;
                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = new Usuario();
                            obj.setCodigo(cod);
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(request.getParameter("txtCPF"));
                            dataNasc = Date.valueOf(request.getParameter("txtDataNasc"));
                            dataNasc = Date.valueOf(df.format(dataNasc));
                            obj.setDataNascimento(dataNasc);
                            obj.setCidade(request.getParameter("txtCidade"));
                            dao.edit(obj);
                            %><h1>Usuário de código <%=obj.getCodigo()%> alterado com sucesso!</h1><%
                            break;
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            dao.destroy(cod);
                            %><h1>Usuário de código <%=cod%> removido com sucesso!</h1><%
                            break;
                        case "Consultar":
                            List<Usuario> lista = dao.findUsuarioEntities();
                            if(lista == null || lista.isEmpty())
                            {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            else
                            {
                                String aux = "";
                                if(lista.size() > 1)
                                    aux = "s";
                                %><h1>Lista com <%=lista.size()%> usuário<%=aux%> encontrado<%=aux%></h1>
                                <table border="1">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Nome</th>
                                            <th>CPF</th>
                                            <th>Data de nascimento</th>
                                            <th>Cidade</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for(int i = 0; i < lista.size(); i++)
                                            {
                                                obj = lista.get(i);
                                                %>
                                                    <tr>
                                                        <td><%=obj.getCodigo()%></td>
                                                        <td><%=obj.getNome()%></td>
                                                        <td><%=obj.getCpf()%></td>
                                                        <td><%=df.format(obj.getDataNascimento())%></td>
                                                        <td><%=obj.getCidade()%></td>
                                                    </tr>
                                                <%
                                            }
                                            %>
                                    </tbody>
                                </table>
                                <%

                            }
                            break;
                        default:
                            throw new Exception("Erro inesperado ao ler evento do botão.");
                    }
                    Banco.conexao.close();
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
                %><h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário<%
            }
            %>
            
    </body>
</html>
