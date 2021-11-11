<%--
create table usuario_apl(
	codigo serial primary key,
	cpf varchar(14),
	nome varchar(40),
	tipo_pessoa varchar(1)
);
--%>
<%@page import="model.UsuarioApl"%>
<%@page import="controller.UsuarioAplJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="model.Banco"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gerenciamento de gestores e enfermeiros</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript" src="javascript/js_geral.js"></script>
        <link rel="stylesheet" href="estilo/style.css">
    </head>
    <body>
        <div class="home_content">
            <div class="title">Gestor e enfermeiro</div>
        <%
            request.setCharacterEncoding("UTF-8");
            UsuarioApl obj;
            String b, t;
            UsuarioAplJpaController dao;
            Banco bb;
            
            try 
            {
                if(session.getAttribute("login") == null || session.getAttribute("classe") != UsuarioApl.class)
                    throw new Exception("Log-in não feito ou credenciais insuficientes");
                bb = new Banco();
                dao = new UsuarioAplJpaController(Banco.conexao);
                
                //não há operações crud a fazer
                if(request.getParameter("b1") == null)
                {
                    //não se tem que carregar dados da tabela da consulta
                    if(request.getParameter("bCarregar") == null)
                    {
                        //primeira vez a rodar
                        //FORM CRUD USUARIO A PREENCHER
%>                      
                        <form action="usuarioApl.jsp" method="post" onsubmit="return verificar(1)"/>
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" id="idCod" placeholder="Digite o código"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Nome</span>
                                    <input type="text" name="txtCod" id="idNome" placeholder="Digite o nome"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">CPF</span>
                                    <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()" placeholder="Digite o CPF"/> 
                                </div>
                            </div>
                            <div class="user-type">
                                <span class="title-type">Tipo do funcionário</span>
                                <div class="category">
                                    <span>Gestor</span>
                                    <input type="radio" name="tipo_user" value="G" checked="true"/>
                                    <span>Enfermeiro</span>
                                    <input type="radio" name="tipo_user" value="E"/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/> 
                            </div>
                        </form>
<%
                    }
                    //carregar dados da tabela da consulta
                    else
                    {
                        obj = dao.findUsuarioApl(Integer.parseInt(request.getParameter("bCarregar")));
                        //FORM CARREGADO DE DADOS DE USUARIO DA TABELA
%>
                        <form action="usuarioApl.jsp" method="post" onsubmit="return verificar(1)"/>
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" id="idCod" placeholder="Digite o código" value="<%=obj.getCodigo()%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Nome</span>
                                    <input type="text" name="txtCod" id="idNome" placeholder="Digite o nome" value="<%=obj.getNome()%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">CPF</span>
                                    <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()" placeholder="Digite o CPF" value="<%=obj.getCpf()%>"/> 
                                </div>
                            </div>
                            <%
                                String[] valores = {"", ""};
                                String check = "checked = 'true'";
                                if(obj.getTipoPessoa().equals("G"))
                                    valores[0] = check;
                                else
                                    valores[1] = check;
                            %>
                            <div class="user-type">
                                <span class="title-type">Tipo do funcionário</span>
                                <div class="category">
                                    <span>Gestor</span>
                                    <input type="radio" name="tipo_user" value="G" <%=valores[0]%>/>
                                    <span>Enfermeiro</span>
                                    <input type="radio" name="tipo_user" value="E" <%=valores[1]%>/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/> 
                            </div>
                        </form>
<%
                    }
                }
                //OPERAÇÃO DE CRUD A SER FEITA
                else
                {
                    b = request.getParameter("b1");
                    int cod;
                    String c; //cpf
                    DAOJPA daoJ = new DAOJPA();
                    t = request.getParameter("tipo_user");
                    switch(b)
                    {
                        case "Cadastrar":
                            c = request.getParameter("txtCPF");
                            obj = new UsuarioApl();
                            obj = (UsuarioApl) daoJ.searchCPF(bb, c, obj.getClass());
                            if(obj != null)
                                throw new Exception("O CPF informado já está em uso!");
                            obj = new UsuarioApl();
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(c);
                            obj.setTipoPessoa(t);
                            dao.create(obj);
                            if(t.equals("G"))
                                t = "Gestor";
                            if(t.equals("E"))
                                t = "Enfermeiro";
%>
                            <h1><%=t%> de nome <%=obj.getNome()%> cadastrado com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;
                            
                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findUsuarioApl(cod);
                            if(obj == null)
                                throw new Exception("Esse usuário não existe.");
                            c = request.getParameter("txtCPF");
                            //checando se o cpf que estou alterando é igual ao anterior
                            if(!obj.getCpf().equals(c))
                            {
                                UsuarioApl aux = new UsuarioApl();
                                //checando se cpf para o qual se altera já existe para outra pessoa
                                aux = (UsuarioApl) daoJ.searchCPF(bb, c, obj.getClass());
                                if(aux != null)
                                    throw new Exception("O CPF informado já está em uso!");
                            }
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(c);
                            obj.setTipoPessoa(t);
                            dao.edit(obj);
%>
                            <h1>Usuário de código <%=obj.getCodigo()%> alterado com sucesso!</h1>Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;
                            
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findUsuarioApl(cod);
                            if(obj == null)
                                throw new Exception("Esse usuário não existe.");
                            t = obj.getTipoPessoa();
                            dao.destroy(cod);
                            if(t.equals("G"))
                                t = "Gestor";
                            if(t.equals("E"))
                                t = "Enfermeiro";
%>   
                            <h1><%=t%> de código <%=cod%> removido com sucesso!</h1>Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;
                            
                        case "Consultar":
                            List<UsuarioApl> lista = dao.findUsuarioAplEntities();
                            if(lista == null || lista.isEmpty())
                            {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            else
                            {
                                String aux = "";
                                if(lista.size() > 1)
                                    aux = "s";
%>
                                <h1>Lista com <%=lista.size()%> usuário<%=aux%> encontrado<%=aux%></h1>
                                <div class="tabela">
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Nome</th>
                                                <th>CPF</th>
                                                <th>Tipo de usuário</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
                                        for(int i = 0; i < lista.size(); i++)
                                        {
                                            obj = lista.get(i);
                                            t = obj.getTipoPessoa();
                                            if(t.equals("G"))
                                                t = "Gestor";
                                            if(t.equals("E"))
                                                t = "Enfermeiro";
%>
                                            <tr>
                                                <td><a href="usuarioApl.jsp?bCarregar=<%=obj.getCodigo()%>"><%=obj.getCodigo()%></a></td>
                                                <td><%=obj.getNome()%></td>
                                                <td><%=obj.getCpf()%></td>
                                                <td><%=t%></td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                                </div>
                                Selecione o campo código de um usuário para carregar seus dados no formulário.<br/>
                                Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
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
%>
                <h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
            }
%>
        </div>
    </body>
</html>
