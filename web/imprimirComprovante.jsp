<%-- 
    Document   : imprimirComprovante
    Created on : 01/11/2021, 21:38:43
    Author     : Pedro
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="controller.*"%>
<%@page import="model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Imprimir comprovante</title>
        <script type="text/javascript">
            function imprimir(){
                var conteudo = document.getElementById('idTexto').innerHTML;
                var tela_impressao = window.open();

                tela_impressao.document.write(conteudo);
                tela_impressao.window.print();
                tela_impressao.window.close();
            } 
       </script>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            int cod = Integer.parseInt(request.getParameter("vacinacao"));
            Usuario u;
            Vacinacao vac;
            Lote l;
            VacinacaoJpaController daoVac;
            UsuarioAplJpaController daoU;
            Banco bb = new Banco();
            try
            {
                daoVac = new VacinacaoJpaController(Banco.conexao);
                daoU = new UsuarioAplJpaController(Banco.conexao);
                vac = daoVac.findVacinacao(cod);
                u = vac.getCodigoUsuario();
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat hF = new SimpleDateFormat("HH:mm");
                l = vac.getCodigoLote();
                %>
                 <div id="idTexto" class="print">
                    <div class="head">
                        <h1>Certificado de Aplicação de Vacina - <%=vac.getCodigoAgenda().getDoseNumero()%>ª dose</h1>
                    </div>
                    <div class="body">
                        <fieldset class="dados_pessoais">
                            <legend>Dados Pessoais</legend>
                            <p>Nome: <%=u.getNome()%></p>
                            <p>CPF: <%=u.getCpf()%></p>
                            <p>Data de nascimento: <%=dF.format(u.getDataNascimento())%></p>
                            <p>Cidade: <%=u.getCidade()%></p>
                        </fieldset>
                        <fieldset class="dados_apl">
                            <legend>Dados da Vacinação</legend>
                            <p>Vacina aplicada: <%=l.getCodigoVacina().getDescricao()%></p>
                            <p>Data e hora de aplicação: <%=dF.format(vac.getDataAplicacao()) + " às " + hF.format(vac.getDataAplicacao())%></p>
                            <p>Lote da vacina: <%=l.getDescricao()%></p>
                            <p>Responsável pela aplciação: <%=vac.getCodigoUsuarioApl().getNome()%></p>
                        </fieldset>
                    </div>
                </div><br>
                <input type="button"  value="Imprimir" onclick="imprimir()" />
        <%
                Banco.conexao.close();
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
                %><h1>Erro: <%=ex.getMessage()%></h1><%
            }
        %>
    </body>
</html>
