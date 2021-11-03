<%--
    create table usuario(
        codigo serial primary key,
        cpf varchar(14),
        nome varchar (40),
        data_nascimento date,
        cidade varchar(30)
    );
--%>

<%@page import="controller.DAOJPA"%>
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
        <title>Gerenciamento de usuários</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript" src="javascript/js_geral.js"></script>
    </head>
    <body>
        <a href="index.jsp">Tela inicial</a>
<%
            request.setCharacterEncoding("UTF-8");
            Usuario obj;
            String b;
            UsuarioJpaController dao;
            Banco bb = new Banco();
            Usuario login = new Usuario();
            boolean comum = false;
            try 
            {
                if(session.getAttribute("login") == null)
                    throw new Exception("Faça log-in antes!");
                dao = new UsuarioJpaController(Banco.conexao);
                if(session.getAttribute("classe") == Usuario.class)
                {
                    login = (Usuario) session.getAttribute("login");
                //atualizando o usuário logado para garantir "frescor" dos dados
                    login = dao.findUsuario(login.getCodigo());
                    session.setAttribute("login", login);
                    comum = true;
                }
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy");

                //não há operações crud a fazer
                if(request.getParameter("b1") == null)
                {
                    //não se tem que carregar dados da tabela da consulta
                    if(request.getParameter("bCarregar") == null)
                    {
                        //primeira vez a rodar
                        //FORM CRUD USUARIO A PREENCHER
%>                      
                        <form action="usuario.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" id="idCod" readonly/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome"/> <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()"/> <br/>
                            Data de nascimento: <input type="text" name="txtDataNasc" id="idDataNasc"/> <br/>
                            Cidade: <input type="text" name="txtCidade" id="idCidade"/><br/><br/>
                            <%if(!comum)
                            {
                                %><input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;<%
                            }
%>
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                    //carregar dados da tabela da consulta
                    else
                    {
                        obj = dao.findUsuario(Integer.parseInt(request.getParameter("bCarregar")));
                        //FORM CARREGADO DE DADOS DE USUARIO DA TABELA
%>
                        <form action="usuario.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>" readonly/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome" value="<%=obj.getNome()%>"/>  <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF" value="<%=obj.getCpf()%>"/> <br/>
                            Data de nascimento: <input type="text" name="txtDataNasc" id="idDataNasc" value="<%=dF.format(obj.getDataNascimento())%>"/> <br/>
                            Cidade: <input type="text" name="txtCidade" id="idCidade" value="<%=obj.getCidade()%>"/><br/><br/>
                            <%if(!comum)
                            {
                                %><input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;<%
                            }%>
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
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

                    switch(b)
                    {
                        case "Cadastrar":
                            c = request.getParameter("txtCPF");
                            obj = new Usuario();
                            obj = (Usuario) daoJ.searchCPF(bb, c, obj.getClass());
                            if(obj != null)
                                throw new Exception("O CPF informado já está em uso!");
                            obj = new Usuario();
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(c);
                            obj.setDataNascimento(dF.parse(request.getParameter("txtDataNasc")));
                            obj.setCidade(request.getParameter("txtCidade"));
                            dao.create(obj);
%> 
                            <h1>Usuário de nome <%=obj.getNome()%> cadastrado com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;

                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findUsuario(cod);
                            if(obj == null)
                                throw new Exception("Esse usuário não existe.");
                            c = request.getParameter("txtCPF");
                            //checando se o cpf que estou alterando é igual ao anterior
                            if(!obj.getCpf().equals(c))
                            {
                                Usuario aux = new Usuario();
                                //checando se cpf para o qual se altera já existe para outra pessoa
                                aux = (Usuario) daoJ.searchCPF(bb, c, obj.getClass());
                                if(aux != null)
                                    throw new Exception("O CPF informado já está em uso!");
                            }
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(c);
                            obj.setDataNascimento(dF.parse(request.getParameter("txtDataNasc")));
                            obj.setCidade(request.getParameter("txtCidade"));
                            dao.edit(obj);
%>
                            <h1>Usuário de código <%=obj.getCodigo()%> alterado com sucesso!</h1>Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;

                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findUsuario(cod);
                            if(obj == null)
                                throw new Exception("Esse usuário não existe.");
                            dao.destroy(cod);
%>                          
                            <h1>Usuário de código <%=cod%> removido com sucesso!</h1>
<%
                            if(comum)
                            {
                                session.removeAttribute("login");
                                session.removeAttribute("classe");
%> 
                            <h1>Clique <a href="index.jsp">aqui</a> para voltar à tela inicial</h1> 
<%
                            }
                            else
                            {
%> 
                            <h1>Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário</h1> 
<%
                            }
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
                                if(!comum)
                                {
%>
                                <h1>Lista com <%=lista.size()%> usuário<%=aux%> encontrado<%=aux%></h1><%
                                    }
%>
                                    
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Nome</th>
                                                <th>CPF</th>
                                                <th>Data de nascimento</th>
                                                <th>Cidade</th>
                                                <th>Agendamentos</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
                                        if(comum)
                                        {
                                            %><tr>
                                                <td><a href="usuario.jsp?bCarregar=<%=login.getCodigo()%>"><%=login.getCodigo()%></a></td>
                                                <td><%=login.getNome()%></td>
                                                <td><%=login.getCpf()%></td>
                                                <td><%=dF.format(login.getDataNascimento())%></td>
                                                <td><%=login.getCidade()%></td>
                                                <td><a href="agenda.jsp?b1=Pesquisar&txtCPF=<%=login.getCpf()%>">Acessar</a></td>
                                            </tr><%
                                        }
                                        else
                                        {
                                            for(int i = 0; i < lista.size(); i++)
                                            {
                                                obj = lista.get(i);
    %>
                                                <tr>
                                                    <td><a href="usuario.jsp?bCarregar=<%=obj.getCodigo()%>"><%=obj.getCodigo()%></a></td>
                                                    <td><%=obj.getNome()%></td>
                                                    <td><%=obj.getCpf()%></td>
                                                    <td><%=dF.format(obj.getDataNascimento())%></td>
                                                    <td><%=obj.getCidade()%></td>
                                                    <td><a href="agenda.jsp?b1=Pesquisar&txtCPF=<%=obj.getCpf()%>">Acessar</a></td>
                                                </tr>
    <%
                                            }
                                        }
%>
                                        </tbody>
                                    </table>
                                Selecione o campo código de um usuário para carregar seus dados no formulário.<br/>
                                Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário
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
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
%>
    </body>
</html>