<%-- 
    Document   : controleMovimento
    Created on : 09/10/2021, 17:55:11
    Author     : Pedro
--%>

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
                    throw new Exception("Lista nula ou vazia.");
                }
                else
                {
                    String aux = "";
                                if(lista.size() > 1)
                                    aux = "s";
%>
                                <h1>Lista com <%=lista.size()%> movimento<%=aux%> de vacina encontrado<%=aux%></h1>
                                <table>
                                    <tr>
                                        <th>Código</th>
                                        <th>Vacina</th>
                                        <th>Data</th>
                                        <th>Tipo</th>
                                        <th>Quantidade</th>
                                        <th>Lote</th>
                                    </tr>
                                    <%
                                    for(int i = 0; i < lista.size(); i++)
                                    {
                                        mov = lista.get(i);
                                        %><tr>
                                        <td><%=mov.getCodigo()%></td>
                                        <td><%=mov.getVacina().getDescricao()%></td>
                                        <td><%=mov.getDataMovimento()%></td>
                                        <td><%=mov.getTipoMovimento()%></td>
                                        <td><%=mov.getQtde()%></td>
                                        <td><%=mov.getLote()%></td>
                                        </tr><%
                                    }
                                    %>
                                </table><%
                        
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
