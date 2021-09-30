<%@page import="java.util.List"%>
<%@page import="controller.VacinaJpaController"%>
<%@page import="model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manutenção de vacinas</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript" src="javascript/js_geral.js"></script>
    </head>
    <body>
        <a href="index.jsp">Tela inicial</a>
<%
        request.setCharacterEncoding("UTF-8");
        String b;
        Vacina obj = null;
        Banco bb = new Banco();
        VacinaJpaController dao;
        int cod;
        
        try {
            //SEM FUNÇÕES DO CRUD A EXECUTAR
            //Testando se houve redirecionamento desta página para ela mesma
            if(request.getParameter("b1") == null) {
                //Testando se o programa vai carregar dados da tabela no formulário
                if(request.getParameter("bCarregar") == null) {
%>
                    <form action="vacina.jsp" method="post" onsubmit="return verificar(2)">
                        Código: <input type="text" name="txtCod" id="idCod"/> <br/>
                        Descrição: <input type="text" name="txtDescricao" id="idNome"/> <br/>
                        Doses por unidade: <input type="text" name="txtQtdeDose" id="QtdeDose"/> <br/>
                        <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                    </form>
<%
                }
                //Carregando dados de um registro da tabela no formulário
                else {
                    bb = new Banco();
                    dao = new VacinaJpaController(Banco.conexao);
                    obj = dao.findVacina(Integer.parseInt(request.getParameter("bCarregar")));
                    Banco.conexao.close();
%>
                    <form action="vacina.jsp" method="post" onsubmit="return verificar(2)">
                        Código: <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>"/> <br/>
                        Descrição: <input type="text" name="txtDescricao" id="idNome" value="<%=obj.getDescricao()%>"/> <br/>
                        Doses por unidade: <input type="text" name="txtQtdeDose" id="idQtdeDose" value="<%=obj.getQtdeDose()%>"/> <br/><br/>
                        <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                        <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                    </form>
<%
                }
            }
            //EXECUTAR FUNÇÕES DO CRUD
            else {
                b = request.getParameter("b1");

                switch(b) {
                    case "Cadastrar":
                        obj = new Vacina();
                        obj.setDescricao(request.getParameter("txtDescricao"));
                        obj.setQtdeDose(Integer.parseInt(request.getParameter("txtQtdeDose")));

                        bb = new Banco();
                        dao = new VacinaJpaController(Banco.conexao);
                        dao.create(obj);
%> 
                        <h1>Vacina <%=obj.getDescricao()%> foi cadastrada. Código: <%=obj.getCodigo()%></h1>Clique <a href="vacina.jsp">aqui</a> para voltar ao formulário CRUD vacina.
<%
                        Banco.conexao.close();
                        break;

                    case "Alterar":
                        cod = Integer.parseInt(request.getParameter("txtCod"));
                        obj = new Vacina();
                        obj.setCodigo(cod);
                        obj.setDescricao(request.getParameter("txtDescricao"));
                        obj.setQtdeDose(Integer.parseInt(request.getParameter("txtQtdeDose")));
                        
                        bb = new Banco();
                        dao = new VacinaJpaController(Banco.conexao);
                        dao.edit(obj);
%>
                        <h1>Vacina de código <%=obj.getCodigo()%> alterada com sucesso!</h1>Clique <a href="vacina.jsp">aqui</a> para voltar ao formulário CRUD vacina
<%
                        Banco.conexao.close();
                        break;

                    case "Remover":
                        cod = Integer.parseInt(request.getParameter("txtCod"));
                        
                        bb = new Banco();
                        dao = new VacinaJpaController(Banco.conexao);
                        dao.destroy(cod);
%>
                        <h1>Vacina de código <%=cod%> removida com sucesso!</h1>Clique <a href="vacina.jsp">aqui</a> para voltar ao formulário CRUD vacina
<%
                        Banco.conexao.close();
                        break;

                    case "Consultar":
                        bb = new Banco();
                        dao = new VacinaJpaController(Banco.conexao);
                        List<Vacina> lista = dao.findVacinaEntities();
                        
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
                            <h1>Lista com <%=lista.size()%> vacina<%=aux%> encontrada<%=aux%></h1>
                            <form action="vacina.jsp" method="post">
                                <table border="1">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Descrição</th>
                                            <th>Doses por unidade</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
                                        for(int i = 0; i < lista.size(); i++)
                                        {
                                            obj = lista.get(i);
%>
                                            <tr>
                                                <td><input type="submit" name="bCarregar" value="<%=obj.getCodigo()%>"/></td>
                                                <td><%=obj.getDescricao()%></td>
                                                <td><%=obj.getQtdeDose()%></td>
                                            </tr>
<%
                                        }
%>
                                    </tbody>
                                </table>
                            </form>
                            Selecione o campo código de uma vacina para carregar seus dados no formulário.<br/>
                            Clique <a href="vacina.jsp">aqui</a> para voltar ao formulário CRUD vacina
<%
                        }
                        Banco.conexao.close();
                        break;

                    default:
                        throw new Exception("Erro inesperado ao ler evento do botão.");
                }
            }
        }
        catch(Exception ex) {
            Banco.conexao.close();
%>
            <h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="vacina.jsp">aqui</a> para voltar ao formulário CRUD vacina
<%
        }
%>
    </body>
</html>