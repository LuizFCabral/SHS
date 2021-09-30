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
    </head>
    <body>
        <a href="index.jsp">Tela inicial</a>
        <%
            request.setCharacterEncoding("UTF-8");
            UsuarioApl obj;
            String b, t;
            UsuarioAplJpaController dao;
            Banco bb;
            
            try 
            {
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
                        <form action="usuarioApl.jsp" method="post" onsubmit="return verificar(1)"/>&nbsp;&nbsp;
                            Código: <input type="text" name="txtCod" id="idCod"/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome"/> <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF"/> <br/>
                            Tipo de funcionário: Gestor: <input type="radio" name="tipo_user" value="G" checked="true"/>
                            Enfermeiro: <input type="radio" name="tipo_user" value="E"/> <br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/> 
                        </form>
<%
                    }
                    //carregar dados da tabela da consulta
                    else
                    {
                        obj = dao.findUsuarioApl(Integer.parseInt(request.getParameter("bCarregar")));
                        //FORM CARREGADO DE DADOS DE USUARIO DA TABELA
%>
                        <form action="usuarioApl.jsp" method="post" onsubmit="return verificar(1)"/>&nbsp;&nbsp;
                            Código: <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>"/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome" value="<%=obj.getNome()%>"/> <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF" value="<%=obj.getCpf()%>"/> <br/>
                            <%
                                String[] valores = {"", ""};
                                String check = "checked = 'true'";
                                if(obj.getTipoPessoa().equals("G"))
                                    valores[0] = check;
                                else
                                    valores[1] = check;
                            %>
                            Tipo de funcionário: Gestor: <input type="radio" name="tipo_user" value="G" <%=valores[0]%>/>
                            Enfermeiro: <input type="radio" name="tipo_user" value="E" <%=valores[1]%>/> <br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
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
                    Boolean achou;
                    DAOJPA daoJ = new DAOJPA();
                    t = request.getParameter("tipo_user");
                    switch(b)
                    {
                        case "Cadastrar":
                            c = request.getParameter("txtCPF");
                            obj = new UsuarioApl();
                            achou = daoJ.checarCPF(bb, c, obj.getClass());
                            if(achou)
                                throw new Exception("O CPF informado já está em uso!");
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
                                obj = new UsuarioApl();
                                //checando se cpf para o qual se altera já existe para outra pessoa
                                achou = daoJ.checarCPF(bb, c, obj.getClass());
                                if(achou)
                                    throw new Exception("O CPF informado já está em uso!");
                            }
                            obj.setNome(request.getParameter("txtNome"));
                            obj.setCpf(c);
                            obj.setCodigo(cod);
                            obj.setTipoPessoa(t);
                            dao.edit(obj);
%>
                            <h1>Usuário de código <%=obj.getCodigo()%> alterado com sucesso!</h1>Clique <a href="usuarioApl.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
                            break;
                            
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            t = dao.findUsuarioApl(cod).getTipoPessoa();
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
                                <form action="usuarioApl.jsp" method="post">
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
                                                <td><input type="submit" name="bCarregar" value="<%=obj.getCodigo()%>"/></td>
                                                <td><%=obj.getNome()%></td>
                                                <td><%=obj.getCpf()%></td>
                                                <td><%=t%></td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                                </form>
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
    </body>
</html>
