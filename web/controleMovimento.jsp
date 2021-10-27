<%-- 
    Document   : controleMovimento
    Created on : 09/10/2021, 17:55:11
    Author     : Pedro
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="controller.VacinaJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="model.Usuario"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Vacina"%>
<%@page import="java.util.List"%>
<%@page import="model.MovimentoVacina"%>
<%@page import="model.Banco"%>
<%@page import="controller.MovimentoVacinaJpaController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta de movimentos</title>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            MovimentoVacina obj;
            String b;
            MovimentoVacinaJpaController dao;
            VacinaJpaController daoV;
            Banco bb;
            MovimentoVacinaJpaController dao;
            List<MovimentoVacina> lista;
            MovimentoVacina mov;
            try
            {
                bb = new Banco();
                dao = new MovimentoVacinaJpaController(Banco.conexao);
                lista = dao.findMovimentoVacinaEntities();
                if(lista.isEmpty() || lista == null)
                {
                    if(request.getParameter("bCarregar") == null)
                    {
%>                      
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod"/> <br/>
                            Código da vacina: <input type="text" name="txtCodVac"/> <br/>
                            Data do movimento: <input type="datetime-local" name="txtDataMov" readonly/> <br/>
                            Tipo do movimento: <input type="text" name="txtTipo"/> <br/>
                            Quantidade: <input type="text" name="txtQuant"/><br/>
                            Lote: <input type="text" name="txtLote"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                    else
                    {
                        obj = dao.findMovimentoVacina(Integer.parseInt(request.getParameter("bCarregar")));
%>
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" value="<%=obj.getCodigo()%>"/> <br/>
                            Código da vacina: <input type="text" name="txtCodVac" value="<%=obj.getCodigoVacina().getCodigo()%>"/> <br/>
                            Data do movimento: <input type="datetime-local" name="txtDataMov" readonly value="<%--<%=dataHora.format((obj.getDataMovimento().toString()))%>--%>"/> <br/>
                            Tipo do movimento: <input type="text" name="txtTipo" value="<%=obj.getTipoMovimento()%>"/> <br/>
                            Quantidade: <input type="text" name="txtQuant" value="<%=obj.getQtde()%>"/><br/>
                            Lote: <input type="text" name="txtLote" value="<%=obj.getLote()%>"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                }
                else
                {
                    b = request.getParameter("b1");
                    int cod;
                    switch(b)
                    {
                        case "Cadastrar":
                            obj = new MovimentoVacina();
                            obj.setCodigoVacina(daoV.findVacina(Integer.parseInt(request.getParameter("txtCodVac"))));
                            //obj.setDataMovimento(dataHora.parse(request.getParameter("txtDataMov")));
                            obj.setTipoMovimento(request.getParameter("txtTipo"));
                            obj.setQtde(Integer.parseInt(request.getParameter("txtQuant")));
                            obj.setLote(Integer.parseInt(request.getParameter("txtLote")));
                            dao.create(obj);
%> 
                            <h1>Movimento de <%=obj.completarTipo()%> cadastrado com sucesso. </h1>
<%
                            break;
                            
                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findMovimentoVacina(cod);
                            if(obj == null)
                                throw new Exception("Esse movimento não existe.");
                            obj.setCodigoVacina(daoV.findVacina(Integer.parseInt(request.getParameter("txtCodVac"))));
                            //obj.setDataMovimento(dF.parse(request.getParameter("txtDataMov")));
                            obj.setTipoMovimento(request.getParameter("txtTipo"));
                            obj.setQtde(Integer.parseInt(request.getParameter("txtQuant")));
                            obj.setLote(Integer.parseInt(request.getParameter("txtLote")));
                            dao.edit(obj);
%>
<h1>Movimento de <%=obj.completarTipo()%> alterado com sucesso. </h1><%
                            break;
                            
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findMovimentoVacina(cod);
                            if(obj == null)
                                throw new Exception("Esse movimento não existe.");
                            dao.destroy(cod);
%>
                           <h1>Movimento de <%=obj.completarTipo()%> removido com sucesso.</h1>
<%
                            break;
                            
                        case "Consultar":
                            List<MovimentoVacina> lista = dao.findMovimentoVacinaEntities();
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
                                <h1>Lista com <%=lista.size()%> movimento<%=aux%> encontrado<%=aux%></h1>
                                <form action="controleMovimento.jsp" method="post">
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Código da vacina</th>
                                                <th>Data do movimento</th>
                                                <th>Tipo</th>
                                                <th>Quantidade</th>
                                                <th>Lote</th>
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
                                                <td><%=obj.getCodigoVacina().getCodigo()%></td>
                                                <td>n implementado<%--<%=dataHora.format(dataHora.format((obj.getDataMovimento().toString())))%>--%></td>
                                                <td><%=obj.completarTipo()%></td>
                                                <td><%=obj.getQtde()%></td>
                                                <td><%=obj.getLote()%></td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                                </form>
                                Selecione o campo código de um movimento para carregar seus dados no formulário.<br/>
<%
                            }
                            break;

                        default:
                            throw new Exception("Erro inesperado ao ler evento do botão.");
                    }
                    Banco.conexao.close();
                }
                Banco.conexao.close();
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
