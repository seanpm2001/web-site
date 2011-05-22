<?xml version="1.0" encoding="UTF-8"?>
<!--
Author: Tim Cuthbertson
Modified by Thomas Leonard.
License: Creative Commons Attribution-ShareAlike 2.5 license
http://creativecommons.org/licenses/by-sa/2.5/
-->
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:zi="http://zero-install.sourceforge.net/2004/injector/interface"
		version="1.0">
	<xsl:output method="xml" encoding="utf-8" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>
	<xsl:template match="/zi:interface">
		<html>
			<head>
				<title>
					<xsl:value-of select="zi:name"/>
				</title>
				<link rel="stylesheet" type="text/css" href='/feed.css'/>
			</head>
			<body>
				<div class="site">
					<div class="title"> 
						<a href="/"> 
							0install.net
						</a> 
					</div>
					<div class="main">
						<div class="content">
							<div class="post inner">

								<xsl:variable name="icon-href" select="(zi:icon[@type='image/png'][1])/@href"/>
								<xsl:if test="$icon-href != ''">
									<img src="{$icon-href}" class="alpha icon" />
								</xsl:if>

								<h1><xsl:value-of select="zi:name"/></h1>
								<h2><xsl:value-of select='zi:summary'/></h2>

								<div class="what-is-this">
									This page is a <a href="http://0install.net/">zero-install</a> feed.
									If you don't know what that is or how to use it, you're in luck - see the
									<a href="#what-is-this">instructions at the bottom of this page</a>
								</div>

								<dl>
									<xsl:apply-templates mode="dl" select="*|@*"/>

									<dt>Required libraries</dt>
									<dd>
										<xsl:choose>
											<xsl:when test="//zi:requires|//zi:runner">
												<p class="yourinfo">
													(Zero Install will automatically download any required libraries for you)
												</p>
												<ul>
													<xsl:for-each select="//zi:requires|//zi:runner">
														<xsl:variable name="interface" select="@interface"/>
														<xsl:if test="not(preceding::zi:requires[@interface = $interface]) and not(preceding::zi:runner[@interface = $interface])">
															<li>
																<a>
																	<xsl:attribute name="href">
																		<xsl:value-of select="$interface"/>
																	</xsl:attribute>
																	<xsl:value-of select="$interface"/>
																</a>
															</li>
														</xsl:if>
													</xsl:for-each>
												</ul>
											</xsl:when>
											<xsl:otherwise>
												<p>This feed does not list any additional requirements.</p>
											</xsl:otherwise>
										</xsl:choose>
									</dd>


									<dt>Available versions</dt>
									<dd>
										<xsl:choose>
											<xsl:when test="//zi:implementation">
												<p class="yourinfo">
													(Zero Install will automatically download one of these versions for you)
											</p>
												<table cellpadding="0" cellspacing="0">
													<tr>
														<th>Version</th>
														<th>Released</th>
														<th>Stability</th>
														<th>Platform</th>
														<th>Download</th>
													</tr>
													<xsl:for-each select="//zi:implementation">
														<tr>
															<td>
																<xsl:value-of select="(ancestor-or-self::*[@version])[last()]/@version"/>
																<xsl:if test="(ancestor-or-self::*[@version])[last()]/@version-modifier">
																	<xsl:value-of select="(ancestor-or-self::*[@version])[last()]/@version-modifier"/>
																</xsl:if>
															</td>
															<td>
																<xsl:value-of select="(ancestor-or-self::*[@released])[last()]/@released"/>
															</td>
															<td>
																<xsl:value-of select="(ancestor-or-self::*[@stability])[last()]/@stability"/>
															</td>
															<td>
																<xsl:variable name="arch" select="(ancestor-or-self::*[@arch])[last()]/@arch"/>
																<xsl:choose>
																	<xsl:when test="$arch = &quot;*-src&quot;">Source code</xsl:when>
																	<xsl:when test="not($arch)">Any</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$arch"/>
																	</xsl:otherwise>
																</xsl:choose>
															</td>
															<td>
																<xsl:for-each select=".//zi:archive"><a href="{@href}">Download</a> (<xsl:value-of select="@size"/> bytes)
																</xsl:for-each>
															</td>
														</tr>
													</xsl:for-each>
												</table>
												


											</xsl:when>
											<xsl:otherwise>
												<p>No versions are available for downlad.</p>
											</xsl:otherwise>
										</xsl:choose>
									</dd>

								</dl>
							</div>
						</div>
						<div class="clear"/>
					</div>
					<div class="chrome">
						<div class="inner">


								<div class="explanation">
									<a name="what-is-this"></a>
									<h3>What is this page, and how do I use it?</h3>
									<xsl:choose>
										<xsl:when test="//zi:implementation[@main] | //zi:group[@main] | //zi:command[@name='run']">

											<p>This is a runnable Zero Install feed. To add this program to your Applications menu, choose
												<b>Zero Install -&gt; Add New Program</b> from the <b>Applications</b> menu, and drag this
												feed's URL into the window it opens.
												If you don't see this menu item, install the <code>zeroinstall-injector</code> package from your
												distribution's repository, or from <a href="http://0install.net/injector.html">0install.net</a>.
											</p>
											<p>Alternatively, to run it from the command-line:<br/>
											<pre>0launch <xsl:value-of select="/zi:interface/@uri"/></pre>
											</p>
											<p>
												The <code>0alias</code> command can be used to create a short-cut to run it again later.
												If you don't have the <code>0launch</code> command, download it from
												<a href="http://0install.net/injector.html">0install.net</a>, which also contains
												documentation about how the Zero Install system works.</p>

										</xsl:when>
										<xsl:otherwise>

											<p>This is a Zero Install feed.
											This software cannot be run as an application directly. It is a library for other programs to use.</p>
											<p>For more information about using Zero Install packages, see the <a href="http://0install.net/dev.html">0install.net developer's guide</a>.</p>

										</xsl:otherwise>
									</xsl:choose>
									<a href="#">back to top.</a>
								</div>
						</div>
					</div>
				</div>
				<!--
				<div class="clear"/>
				<div class="inner footer">
				</div>
				-->
			</body>
		</html>
	</xsl:template>




	<xsl:template mode="dl" match="/zi:interface/@uri">
		<dt>Full URL</dt>
		<dd>
			<p>
				<a href="{.}">
					<xsl:value-of select="."/>
				</a>
			</p>
		</dd>
	</xsl:template>
	<xsl:template mode="dl" match="zi:homepage">
		<dt>Homepage</dt>
		<dd>
			<p>
				<a href="{.}">
					<xsl:value-of select="."/>
				</a>
			</p>
		</dd>
	</xsl:template>

	<xsl:template mode="dl" match="zi:description">
		<dt>Description</dt>
		<dd class="description">
			<xsl:call-template name='description'>
				<xsl:with-param name='text'><xsl:value-of select='.'/></xsl:with-param>
			</xsl:call-template>
		</dd>
	</xsl:template>

	<xsl:template name='description'>
		<xsl:param name="text"/>
		<xsl:if test='normalize-space($text)'>
			<xsl:variable name='first' select='substring-before($text, "&#xa;&#xa;")'/>
			<xsl:if test='normalize-space($first)'>
			  <p><xsl:value-of select='$first'/></p>
			</xsl:if>
			<xsl:call-template name='description'>
				<xsl:with-param name='text'><xsl:value-of select='substring-after($text, "&#xa;&#xa;")'/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- <xsl:template mode="dl" match="zi:icon"> -->
	<!-- 	<dt>Icon</dt> -->
	<!-- 	<dd> -->
	<!-- 		<p> -->
	<!-- 			<img src="{@href}" class="alpha"/> -->
	<!-- 		</p> -->
	<!-- 	</dd> -->
	<!-- </xsl:template> -->
	<xsl:template mode="dl" match="*|@*"/>
	<xsl:template match="zi:group">
		<dl class="group">
			<xsl:apply-templates mode="attribs" select="@stability|@version|@id|@arch|@released"/>
			<xsl:apply-templates select="zi:group|zi:requires|zi:runner|zi:implementation"/>
		</dl>
	</xsl:template>
	<xsl:template match="zi:requires | zi:runner">
		<dt>Requires</dt>
		<dd>
			<a href="{@interface}">
				<xsl:value-of select="@interface"/>
			</a>
		</dd>
	</xsl:template>
	<xsl:template match="zi:implementation">
		<dl class="impl">
			<xsl:apply-templates mode="attribs" select="@stability|@version|@id|@arch|@released"/>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template mode="attribs" match="@*">
		<dt>
			<xsl:value-of select="name(.)"/>
		</dt>
		<dd>
			<xsl:value-of select="."/>
		</dd>
	</xsl:template>
	<xsl:template match="zi:archive">
		<dt>Download</dt>
		<dd><a href="{@href}"><xsl:value-of select="@href"/></a>
		(<xsl:value-of select="@size"/> bytes)</dd>
	</xsl:template>
</xsl:stylesheet>
