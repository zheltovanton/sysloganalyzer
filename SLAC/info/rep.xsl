<?xml version="1.0" encoding="ISO-8859-1" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!--
	
	Futuremark SystemInfo Explorer XSLT StyleSheet

	-->	


	<!-- Global Definitions -->
	
	<xsl:output method="html" omit-xml-declaration="no" encoding="iso-8859-1" indent="no"/>

	<xsl:strip-space elements="*" />
		
	<xsl:attribute-set name="DataTableAttr">
		<xsl:attribute name="cellpadding">2</xsl:attribute>
		<xsl:attribute name="cellspacing">0</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="EntityTableAttr">
		<xsl:attribute name="cellpadding">3</xsl:attribute>
		<xsl:attribute name="cellspacing">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="CompactTableAttr">
		<xsl:attribute name="cellpadding">0</xsl:attribute>
		<xsl:attribute name="cellspacing">0</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="ToggleLinkAttr">
		<xsl:attribute name="onClick">JavaScript: toggleLinkClicked();</xsl:attribute>
		<xsl:attribute name="onSelectStart">JavaScript: return false;</xsl:attribute>
		<xsl:attribute name="onMouseOver">JavaScript: toggleLinkOnMouseOver();</xsl:attribute>
		<xsl:attribute name="onMouseOut">JavaScript: toggleLinkOnMouseOut();</xsl:attribute>
		<xsl:attribute name="style">cursor: hand;</xsl:attribute>		
	</xsl:attribute-set>







	

	<!-- Main Template -->

	<xsl:template match="/System_Info">
		<html>
			<head>
				<title>Miridix Syslog Analizer</title>		

				<script language="JavaScript">
					if ( location.host != '' ) {
						document.write('<base href="'+location.protocol+'//'+location.host+'/sa/global/xslt/"/>');
					}
				
					var d = document.all;
					var js = false;
					if ( navigator.userAgent.indexOf("MSIE") > -1
							&amp;&amp; navigator.userAgent.indexOf("Win") > -1
							&amp;&amp; navigator.userAgent.search("MSIE 1|MSIE 2|MSIE 3|MSIE 4") == -1 ) {
						js = true;
					}
					var imgOpenedSymbol = "images/arrow_down.gif";
					var imgClosedSymbol = "images/arrow_right.gif";
					function setDisplayAll( image ) {
						if ( js ) {
							for ( var i = 0; i &lt; d.toggleImage.length; i++ ) {
								if ( d.toggleImage[i].src != image ) {
									d.toggleImage[i].src = image;
								}
							}
						}
					}
					function toggleLinkClicked() {
						if ( js ) {
							var obj = event.srcElement;
							if ( obj.id != "toggleImage" ) {
								obj = obj.childNodes.item('toggleImage');
							}
							obj.src.search(imgOpenedSymbol) > -1 ? obj.src = imgClosedSymbol : obj.src = imgOpenedSymbol;
						}
					}
					function toggleImageChanged() {
						if ( js ) {
							var disp;
							event.srcElement.src.search(imgOpenedSymbol) > -1 ? disp = "block" : disp = "none";
							var obj = event.srcElement.parentElement.parentElement.parentElement.parentElement;
							for ( var i = 0; i &lt; obj.rows.length; i++ ) {
								if ( obj.rows[i].id == "hide" ) {
									obj.rows[i].style.display = disp;
								}
							}
						}
					}
					function toggleLinkOnMouseOver() {
						if ( js ) {
							var obj = event.srcElement;
							obj.tagName == 'IMG' ? obj = obj.parentElement : null;
							if ( obj.className == 'main' ) {
								obj.style.backgroundColor = '#C0C1C4';
							} else {
								obj.style.backgroundColor = '#C0C1C4';
							}
						}
					}
					function toggleLinkOnMouseOut() {
						if ( js ) {
							var obj = event.srcElement;
							obj.tagName == 'IMG' ? obj = obj.parentElement : null;
							if ( obj.className == 'main' ) {
								obj.style.backgroundColor = '#DBE0E5';
							} else {
								obj.style.backgroundColor = '#DBE0E5';
							}
						}
					}
					function setDisplaySummary() {
						if ( js ) {
							for ( var i = 0; i &lt; d.toggleImage.length; i++ ) {
								var image;
								if ( d.toggleImage[i].parentElement.parentElement.parentElement.parentElement.parentElement == document.all.masterContainer ) {
									image = imgOpenedSymbol;
								} else {
									image = imgClosedSymbol;
								}
								if ( d.toggleImage[i].src != image ) {
									d.toggleImage[i].src = image;
								}
							}
						}
					}
					function copyHTML( sourceObj, destObj ) {						
						if ( js ) {
							destObj.innerHTML = sourceObj.innerHTML;
						}
					}
					function startItUp() {
						if ( js ) {
							d.navButton[0].imagename = "expand";
							d.navButton[1].imagename = "collapse";
							d.navButton[2].imagename = "summary";
							for ( var i = 0; i &lt; d.navButton.length; i++ ) {
								d.navButton[i].onmouseover = navButtonMouseOver;
								d.navButton[i].onmouseout = navButtonMouseOut;
								d.navButton[i].onmousedown = navButtonMouseDown;
								d.navButton[i].onmouseup = navButtonMouseUp;
							}
							copyHTML( d.ProcessList_Name, d.ProcessList );							
							setDisplaySummary();
						}
					}
					function navButtonMouseOver() {
						this.src = 'images/button_' + this.imagename + '_focus.gif';
					}
					function navButtonMouseOut() {
						this.src = 'images/button_' + this.imagename + '_up.gif';
					}
					function navButtonMouseDown() {
						this.src = 'images/button_' + this.imagename + '_down.gif';
					}
					function navButtonMouseUp() {
						this.src = 'images/button_' + this.imagename + '_focus.gif';
					}
				</script>
		        <link type="text/css" rel="stylesheet" href="rep.css"/>
			</head>


			<body topmargin="3" bottommargin="3" leftmargin="3" rightmargin="3" onLoad="JavaScript: startItUp();">

				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
					<tr>
						<td colspan="3">
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td><a href="http://www.futuremark.com"><img src="images/header_1.gif" alt="" width="415" height="64" border="0" /></a></td>
									<td style="background: url(images/header_2.gif);" width="100%"><img src="images/1x1pix.gif" alt="" width="1" height="64" border="0" /></td>
									<td><img src="images/header_3.gif" alt="" width="292" height="64" border="0" /></td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr>
						<td><img src="images/1x1pix.gif" alt="" width="15" height="1" border="0" /></td>
						<td width="100%" height="100%" valign="top" id="masterContainer">
							<br/>
	
							<table cellpadding="0" cellspacing="0" border="0" width="100%"><tr>
								<td nowrap="nowrap">
									<script language="JavaScript">
									if ( js ) {
										document.writeln('<a href="JavaScript:setDisplayAll( imgOpenedSymbol );"><img id="navButton" src="images/button_expand_up.gif" alt="" width="100" height="30" border="0" /></a> ');
										document.writeln('<a href="JavaScript:setDisplayAll( imgClosedSymbol );"><img id="navButton" src="images/button_collapse_up.gif" alt="" width="100" height="30" border="0" /></a> ');
										document.writeln('<a href="JavaScript:setDisplaySummary();"><img id="navButton" src="images/button_summary_up.gif" alt="" width="100" height="30" border="0" /></a>');
									}
									</script>
									&#160;
								</td>
								<td align="right" nowrap="nowrap" class="disclaimer" valign="top">
									SystemInfo version <xsl:value-of select="Version" /><br/>
									XSLT StyleSheet version 3.09c-d
								</td>
							</tr></table>
							
							<br />
							
							<xsl:apply-templates />
	
						</td>		
						<td><img src="images/1x1pix.gif" alt="" width="15" height="1" border="0" /></td>
					</tr>
				
					<tr>
						<td colspan="3">
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td><img src="images/footer_01.gif" alt="" width="1" height="65" border="0" /></td>
									<td style="background: url(images/footer_02.gif);" width="100%"><img src="images/footer_02.gif" alt="" width="283" height="65" border="0" /></td>
									<td><img src="images/footer_03.gif" alt="" width="310" height="65" border="0" /></td>
								</tr>
							</table>
						</td>
					</tr>		
				</table>
			</body>
		</html>
	</xsl:template>

	
	
	

	
	


	<!-- Master Template for Main Categories-->
	
	<xsl:template match="/System_Info/*[descendant::text()]">
			<table cellpadding="4" cellspacing="1" border="0" width="100%">
				<tr>
					<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
						<xsl:attribute name="class">main</xsl:attribute>
						<xsl:call-template name="ToggleDisplayImage" />
						<xsl:text> </xsl:text><xsl:apply-templates select="." mode="title" />	
					</xsl:element>
				</tr>
				<tr id="hide">
					<td style="background: #F4F6F7;">
						<xsl:apply-templates select="." mode="content" />
					</td>
				</tr>
			</table>
			<br/>
	</xsl:template>

	<xsl:template match="System_Info/Version|System_Info/Installation_ID|System_Info/OEM_ID" />



	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
		
	
	

	<!-- CPU Info -->

	<xsl:template match="CPU_Info" mode="content"><xsl:apply-templates /></xsl:template>	
	<xsl:template match="Central_Processing_Unit">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">4</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					CPU <xsl:value-of select="position()"/>/<xsl:value-of select="count(../Central_Processing_Unit)"/>
				</xsl:element>
			</tr>
			<tr>
				<td colspan="4">
					<h3 class="dyndata"><xsl:value-of select="Manufacturer"/>&#160;<xsl:value-of select="Family"/>&#160;<xsl:apply-templates select="Internal_Clock" /></h3>
				</td>
			</tr>
			<tr id="hide">
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="3" />
					<xsl:with-param name="nodeset" select="*[(name() != 'Caches') and (name() != 'CPUIDs') and (name() != 'Ext_CPUIDs') and descendant::text()]" />
				</xsl:call-template>	
				<td>
					<h3>Caches</h3>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="Caches/Cache" mode="DataTableElement" />
					</xsl:element>
				</td>			
			</tr>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Caches/*" mode="name">
		Level <xsl:value-of select="Level" />
	</xsl:template>	
	<xsl:template match="Caches/*">
		<xsl:apply-templates select="Capacity" />
	</xsl:template>


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	<!-- DirectX Info -->

	<xsl:template match="DirectX_Info" mode="content">
		
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="DataTableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="*[text()]" />
			</xsl:call-template>
		</xsl:element>
	
		<hr/>
	
		<h2>DirectDraw</h2>

		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="DataTableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="DirectDraw_Info/*[text()]" />
			</xsl:call-template>
		</xsl:element>

		<xsl:apply-templates select="DirectDraw_Info/Display_Devices/Display_Device" />

		<hr/>
		
		<h2>DirectShow</h2>

		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="DataTableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="*[text()]" />
			</xsl:call-template>
		</xsl:element>

		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">3</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					Registered DirectShow Filters
				</xsl:element>
			</tr>
			<tr id="hide">
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="3" />
					<xsl:with-param name="nodeset" select="DirectShow_Info/Registered_DirectShow_Filters/Filter" />
				</xsl:call-template>
			</tr>
		</xsl:element>

		<hr/>
		
		<h2>DirectSound</h2>
		
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="DataTableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="DirectSound_Info/*[text()]" />
			</xsl:call-template>
		</xsl:element>
		
		<xsl:apply-templates select="DirectSound_Info/Sound_Devices/Sound_Device" />

	</xsl:template>

	<xsl:template match="Registered_DirectShow_Filters/Filter" mode="DataTableElement">
		<tr>
			<td class="dyndata"><xsl:value-of select="." />&#160;&#160;</td>
		</tr>
	</xsl:template>

	<xsl:template match="Display_Devices/Display_Device">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">3</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					Display Device <xsl:value-of select="position()"/>/<xsl:value-of select="count(../Display_Device)"/>
				</xsl:element>
			</tr>
			<tr>
				<td colspan="3">
					<table cellpadding="0" cellspacing="0" border="0" style="margin-top: 0px; margin-bottom: 0px;">
						<tr>
							<td>
								<h3 class="dyndata"><xsl:value-of select="PCI/Name"/></h3>
							</td>
							<td>&#160;&#160;&#160;&#160;&#160;&#160;</td>
							<td style="vertical-align: middle;">
								Driver <span class="dyndata"><xsl:value-of select="Driver_Version" /></span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="hide">
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="2" />
					<xsl:with-param name="nodeset" select="*[descendant::text() and (name() != 'PCI') and (name() != 'Texture_Formats') and (name() != 'Capabilities')]" />
				</xsl:call-template>
				<td width="33%" rowspan="2">
					<h3>PCI</h3>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="PCI/*" mode="DataTableElement" />
					</xsl:element>
					
					<hr/>
					
					<h3>Texture Formats</h3>
					<div class="dyndata">
						<xsl:apply-templates select="Texture_Formats/Pixel_Format" />
					</div>					
				</td>
			</tr>
			<tr id="hide">
				<td colspan="2">
					<h3>Capabilities</h3>
					<div class="dyndata">
						<xsl:value-of select="Capabilities" />
					</div>
				</td>
			</tr>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="Texture_Formats/Pixel_Format">
		<xsl:value-of select="." /><br/>
	</xsl:template>

	<xsl:template match="Sound_Devices/Sound_Device">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">3</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					Sound Device <xsl:value-of select="position()"/>/<xsl:value-of select="count(../Sound_Device)"/>
				</xsl:element>
			</tr>
			<tr>
				<td colspan="3">
					<table cellpadding="0" cellspacing="0" border="0" style="margin-top: 0px; margin-bottom: 0px;">
						<tr>
							<td>
								<h3 class="dyndata"><xsl:value-of select="PCI/Name"/></h3>
							</td>
							<td>&#160;&#160;&#160;&#160;&#160;&#160;</td>
							<td style="vertical-align: middle;">
								Driver <span class="dyndata"><xsl:value-of select="Driver_Version" /></span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="hide">
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="2" />
					<xsl:with-param name="nodeset" select="*[descendant::text() and (name() != 'PCI') and (name() != 'Capabilities')]" />
				</xsl:call-template>
				<td width="33%" rowspan="2">
					<h3>PCI</h3>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="PCI/*" mode="DataTableElement" />
					</xsl:element>
				</td>
			</tr>
			<tr id="hide">
				<td colspan="2">
					<h3>Capabilities</h3>
					<div class="dyndata">
						<xsl:value-of select="Capabilities" />
					</div>
				</td>
			</tr>
		</xsl:element>
	</xsl:template>

	
	<!--
	<xsl:template match="DirectX_Info/Version" mode="name">
		DirectX Version
	</xsl:template>
	<xsl:template match="DirectShow_Info/Version" mode="name">
		DirectShow Version
	</xsl:template>	
	<xsl:template match="DirectDraw_Info/Version" mode="name">
		DirectDraw Version
	</xsl:template>
	-->
	
	

	
	


	<!-- Memory Info -->

	<xsl:template match="Memory_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="2" />
					<xsl:with-param name="nodeset" select="*[descendant::text() and name() != 'Memory_Arrays']" />
				</xsl:call-template>		
			</tr>	
		</xsl:element>
		<hr/>
		<xsl:apply-templates select="Memory_Arrays/Memory_Array" />
	</xsl:template>
	
	<xsl:template match="Memory_Array">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
				<xsl:attribute name="colspan">3</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					Memory Array <xsl:value-of select="position()"/>/<xsl:value-of select="count(../Memory_Array)"/>
				</xsl:element>
			</tr>
			<tr id="hide">
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="3" />
					<xsl:with-param name="nodeset" select="*[descendant::text() and name() != 'Memory_Slots']" />
				</xsl:call-template>
			</tr>
			<xsl:if test="Memory_Slots/Memory_Slot">
				<tr id="hide">
					<td colspan="3">									
						<xsl:element name="table" use-attribute-sets="DataTableAttr">
							<xsl:call-template name="TableGenerator">
								<xsl:with-param name="cols" select="4" />
								<xsl:with-param name="nodeset" select="Memory_Slots/Memory_Slot" />
							</xsl:call-template>
						</xsl:element>
					</td>
				</tr>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Memory_Slots/Memory_Slot">
		<xsl:param name="current" select="position()" />
		<xsl:param name="total" select="count( ../* )" />
		<h3>Memory Slot <xsl:value-of select="$current"/>/<xsl:value-of select="$total"/></h3>		
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="*[descendant::text()]" mode="DataTableElement" />
		</xsl:element>
	</xsl:template>





	
	
	
	
	
	<!-- Motherboard Info -->

	<xsl:template match="Motherboard_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<td>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="*[descendant::text() and (name() != 'Card_Slots') and (name() != 'System_Devices') and (name() != 'AGP')]" mode="DataTableElement" />
					</xsl:element>
				</td>
				<td>
					<h3>AGP</h3>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="AGP/*" mode="DataTableElement" />
					</xsl:element>
				</td>
			</tr>	
		</xsl:element>

		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">3</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					Card Slots
				</xsl:element>
			</tr>
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="Card_Slots/*" />
				<xsl:with-param name="trid" select="'hide'" />
			</xsl:call-template>
		</xsl:element>

		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:attribute name="colspan">2</xsl:attribute>
					<xsl:call-template name="ToggleDisplayImage" />
					System Devices
				</xsl:element>
			</tr>
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="2" />
				<xsl:with-param name="nodeset" select="System_Devices/*" />
				<xsl:with-param name="trid" select="'hide'" />
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="Card_Slots/Card_Slot">
		<xsl:param name="current" select="position()" />
		<xsl:param name="total" select="count( ../* )" />
		<h3>Slot <xsl:value-of select="$current"/>/<xsl:value-of select="$total"/> (<xsl:value-of select="Type"/>)</h3>
		<div class="dyndata"><b><xsl:value-of select="PCI/Name" /></b></div>
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="*[name() != 'PCI']" mode="DataTableElement" />
		</xsl:element>
		<br/>
	</xsl:template>

	<xsl:template match="System_Devices/System_Device">
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="PCI/Name" mode="DataTableElement" />
			<xsl:apply-templates select="*[name() != 'PCI']" mode="DataTableElement" />
		</xsl:element>	
	</xsl:template>


	
	


	
	
	
	
	
	<!-- Monitor Info -->

	<xsl:template match="Monitor_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="Monitors/Monitor" />
			</xsl:call-template>
		</xsl:element>	
	</xsl:template>

	<xsl:template match="Monitor_Info/Monitors/Monitor">
		<xsl:param name="current" select="position()" />
		<xsl:param name="total" select="count( ../* )" />
		<h3>Monitor <xsl:value-of select="$current"/>/<xsl:value-of select="$total"/></h3>		
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="*[descendant::text()]" mode="DataTableElement" />
		</xsl:element>
	</xsl:template>


	
	
	
	

	
	
	
	
	
	
	<!-- Power Supply Info -->

	<xsl:template match="Power_Supply_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="4" />
				<xsl:with-param name="nodeset" select="Batteries/Battery" />
			</xsl:call-template>
		</xsl:element>	
	</xsl:template>

	<xsl:template match="Batteries/Battery">
		<xsl:param name="current" select="position()" />
		<xsl:param name="total" select="count( ../* )" />
		<h3>Battery <xsl:value-of select="$current"/>/<xsl:value-of select="$total"/></h3>		
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="*[descendant::text()]" mode="DataTableElement" />
		</xsl:element>
	</xsl:template>
	
	
	
	
	
	
	
	
	
	
	<!-- Operating System Info -->
	
	<xsl:template match="Operating_System_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:call-template name="DataTableGenerator">
					<xsl:with-param name="cols" select="4" />
					<xsl:with-param name="nodeset" select="*[descendant::text() and (name() != 'Applications') and (name() != 'Processes') and (name() != 'Logical_Drives')]" />
				</xsl:call-template>		
			</tr>	
		</xsl:element>
		
		<xsl:element name="table" use-attribute-sets="CompactTableAttr">
			<tr>
				<td class="clear">
					<xsl:element name="table" use-attribute-sets="EntityTableAttr">
						<tr>
							<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
								<xsl:attribute name="colspan">3</xsl:attribute>
								<xsl:call-template name="ToggleDisplayImage" />
								Open Processes
							</xsl:element>
						</tr>
						<tr id="hide">
							<td id="ProcessList">
								<xsl:call-template name="ProcessList_Name" />
							</td>
						</tr>
					</xsl:element>
					<div style="display: none;" id="ProcessList_Name">
						<xsl:call-template name="ProcessList_Name" />
					</div>
					<div style="display: none;" id="ProcessList_PID">
						<xsl:call-template name="ProcessList_PID" />
					</div>
					<div style="display: none;" id="ProcessList_Mem">
						<xsl:call-template name="ProcessList_Mem" />
					</div>
				</td>
				<td class="clear">&#160;</td>
				<td class="clear">
					<xsl:element name="table" use-attribute-sets="EntityTableAttr">
						<tr>
							<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
								<xsl:call-template name="ToggleDisplayImage" />
								Logical Drives
							</xsl:element>
						</tr>
						<tr id="hide">
							<td>
								<xsl:element name="table" use-attribute-sets="DataTableAttr">
									<tr>
										<td><h3>Letter</h3></td>
										<td>&#160;</td>
										<td><h3>Label</h3></td>
										<td>&#160;</td>
										<td><h3>Type</h3></td>
										<td>&#160;</td>
										<td><h3>Capacity</h3></td>
										<td>&#160;</td>
										<td><h3>Available</h3></td>
									</tr>
									<xsl:apply-templates select="Logical_Drives/Logical_Drive" />
								</xsl:element>
							</td>
						</tr>
					</xsl:element>
				</td>
			</tr>
		</xsl:element>
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<tr>
				<xsl:element name="th" use-attribute-sets="ToggleLinkAttr">
					<xsl:call-template name="ToggleDisplayImage" />
					Open Applications
				</xsl:element>
			</tr>
			<tr id="hide">
				<td>
					<xsl:element name="table" use-attribute-sets="DataTableAttr">
						<xsl:apply-templates select="Applications/Application">
							<xsl:sort select="Name" />
						</xsl:apply-templates>
					</xsl:element>
				</td>
			</tr>
		</xsl:element>		
	</xsl:template>

	<xsl:template name="ProcessList_Name">
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:call-template name="ProcessListHeader">
				<xsl:with-param name="sortedby" select="1" />
			</xsl:call-template>
			<xsl:apply-templates select="Processes/Process">
				<xsl:sort select="Name" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template name="ProcessList_PID">
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:call-template name="ProcessListHeader">
				<xsl:with-param name="sortedby" select="2" />
			</xsl:call-template>
			<xsl:apply-templates select="Processes/Process">
				<xsl:sort select="PID" data-type="number" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template name="ProcessList_Mem">
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:call-template name="ProcessListHeader">
				<xsl:with-param name="sortedby" select="3" />
			</xsl:call-template>
			<xsl:apply-templates select="Processes/Process">
				<xsl:sort select="Memory_Usage/DoubleValue/@exp" data-type="number" />
				<xsl:sort select="Memory_Usage/DoubleValue" data-type="number" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
		
	<xsl:template name="ProcessListHeader">
		<xsl:param name="sortedby" select="1" />
		<tr>
			<xsl:choose>
				<xsl:when test="$sortedby = '1'">
					<td><h3><i><a href="JavaScript: copyHTML( d.ProcessList_Name, d.ProcessList );">Name</a></i></h3></td>
				</xsl:when>
				<xsl:otherwise>
					<td><h3><a href="JavaScript: copyHTML( d.ProcessList_Name, d.ProcessList );">Name</a></h3></td>
				</xsl:otherwise>
			</xsl:choose>
			<td>&#160;</td>
			<xsl:choose>
				<xsl:when test="$sortedby = '2'">
					<td><h3><i><a href="JavaScript: copyHTML( d.ProcessList_PID, d.ProcessList );">PID</a></i></h3></td>
				</xsl:when>
				<xsl:otherwise>
					<td><h3><a href="JavaScript: copyHTML( d.ProcessList_PID, d.ProcessList );">PID</a></h3></td>
				</xsl:otherwise>
			</xsl:choose>
			<td>&#160;</td>
			<xsl:choose>
				<xsl:when test="$sortedby = '3'">
					<td><h3><i><a href="JavaScript: copyHTML( d.ProcessList_Mem, d.ProcessList );">Memory&#160;Usage</a></i></h3></td>
				</xsl:when>
				<xsl:otherwise>
					<td><h3><a href="JavaScript: copyHTML( d.ProcessList_Mem, d.ProcessList );">Memory&#160;Usage</a></h3></td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template match="Applications/Application">
		<tr>
			<td class="dyndata"><xsl:value-of select="." /></td>
		</tr>
	</xsl:template>	
	
	<xsl:template match="Processes/Process">
		<tr class="dyndata">
			<td><xsl:apply-templates select="Name" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="PID" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="Memory_Usage" /></td>
		</tr>
	</xsl:template>	
	
	<xsl:template match="Logical_Drives/Logical_Drive">
		<tr class="dyndata">
			<td><xsl:apply-templates select="Drive_Letter" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="Label" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="Type" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="Capacity" /></td>
			<td>&#160;</td>
			<td><xsl:apply-templates select="Available" /></td>
		</tr>
	</xsl:template>	

	

	


	
	

	
	
	
	
	<!-- Hard Disk Info -->
	
	<xsl:template match="Hard_Disk_Info" mode="content">
		<xsl:element name="table" use-attribute-sets="EntityTableAttr">
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="3" />
				<xsl:with-param name="nodeset" select="Hard_Disk_Drives/Hard_Disk_Drive" />
			</xsl:call-template>
		</xsl:element>	
	</xsl:template>

	<xsl:template match="Hard_Disk_Info/Hard_Disk_Drives/Hard_Disk_Drive">
		<xsl:param name="current" select="position()" />
		<xsl:param name="total" select="count( ../* )" />
		<h3>Hard Disk Drive <xsl:value-of select="$current"/>/<xsl:value-of select="$total"/></h3>		
		<xsl:element name="table" use-attribute-sets="DataTableAttr">
			<xsl:apply-templates select="*[descendant::text()]" mode="DataTableElement" />
		</xsl:element>
	</xsl:template>
	

	
	
	
	
	

	

	
	
	
	
	<!-- Main Categories End - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	
	
	
	
	
	

	
	
	<!-- General Name Templates -->	
	
	<xsl:template match="*" mode="name" priority="-1"><xsl:value-of select="translate(name(), '_', ' ')" /></xsl:template>
	<xsl:template match="*" mode="title" priority="-1"><xsl:value-of select="translate(name(), '_', ' ')" /></xsl:template>

	

	
	
	


	<!-- DataTable Elements -->
	
	<xsl:template match="*" mode="DataTableElement" priority="-1">
		<xsl:param name="nowrap" />
		<xsl:if test="descendant::text()">
			<tr>
				<xsl:element name="td">
					<xsl:attribute name="class">valuename</xsl:attribute>										
					<xsl:if test="$nowrap != ''">
						<xsl:attribute name="nowrap">nowrap</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="." mode="name" />
				</xsl:element>
				<td>&#160;</td>
				<xsl:element name="td">
					<xsl:attribute name="class">dyndata</xsl:attribute>										
					<xsl:if test="$nowrap != ''">
						<xsl:attribute name="nowrap">nowrap</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="." />
				</xsl:element>
				<td>&#160;&#160;&#160;</td>
			</tr>
		</xsl:if>
	</xsl:template>




	

	<!-- Value Handlers and Formatters -->
	
	<xsl:template name="DoubleValueHandler">
		<xsl:param name="value" select="1" />
		<xsl:param name="base" select="1" />
		<xsl:param name="exp" select="1" />
		<xsl:param name="unit" select="1" />
		<xsl:choose>
			<xsl:when test="$base = 10 and $exp = 0">
				<xsl:value-of select="format-number($value, '0.0')" />&#160;<xsl:value-of select="$unit" />
			</xsl:when>
			<xsl:when test="$base = 10 and $exp = 6 and $unit = 'Hz'">
				<xsl:value-of select="format-number($value, '0.0')" />&#160;MHz
			</xsl:when>
			<xsl:when test="$base = 10 and $exp = 9 and $unit = 'Hz'">
				<xsl:value-of select="format-number($value, '0.0')" />&#160;GHz
			</xsl:when>
			<xsl:when test="$base = 2 and $exp = 0 and $unit = 'B'">
				<xsl:value-of select="format-number($value, '0')" />&#160;B
			</xsl:when>
			<xsl:when test="$base = 2 and $exp = 10 and $unit = 'B'">
				<xsl:value-of select="format-number($value, '0')" />&#160;KB
			</xsl:when>
			<xsl:when test="$base = 2 and $exp = 20 and $unit = 'B'">
				<xsl:value-of select="format-number($value, '0')" />&#160;MB
			</xsl:when>
			<xsl:when test="$base = 2 and $exp = 30 and $unit = 'B'">
				<xsl:value-of select="format-number($value, '0.00')" />&#160;GB
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="DoubleValue">
		<xsl:choose>
			<xsl:when test="@base = 16 and @unit = 'B'">
				<xsl:call-template name="DoubleValueHandler">
					<xsl:with-param name="value">
						<xsl:call-template name="power">
							<xsl:with-param name="base" select="2" />
							<xsl:with-param name="exp" select="(@exp * 4) mod 10" />
							<xsl:with-param name="factor" select="." />
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="base" select="2" />
					<xsl:with-param name="exp" select="(@exp * 4) - ( (@exp * 4) mod 10 )" />
					<xsl:with-param name="unit" select="@unit" />
				</xsl:call-template>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:call-template name="DoubleValueHandler">
					<xsl:with-param name="value" select="." />
					<xsl:with-param name="base" select="@base" />
					<xsl:with-param name="exp" select="@exp" />
					<xsl:with-param name="unit" select="@unit" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="IntValue">
		<xsl:choose>
			<xsl:when test="@base = 10 and @exp = 0">
				<xsl:value-of select="format-number(., '0')" />&#160;<xsl:value-of select="@unit" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="EnumValue">
		<xsl:apply-templates select="String" />				
	</xsl:template>



	
	

	<!-- Table Generator -->

	<xsl:template name="TableGenerator">
		<xsl:param name="cols" select="2" />
		<xsl:param name="nodeset" />
		<xsl:param name="nodecounter" select="1" />
		<xsl:param name="trid" />
		<tr id="{$trid}">
			<xsl:apply-templates select="$nodeset[position() >= $nodecounter and position() &lt; $nodecounter + $cols]" mode="TableGeneratorColumn">
				<xsl:with-param name="rownode" select="$nodecounter" />
				<xsl:with-param name="total" select="count($nodeset)" />
			</xsl:apply-templates>
			<xsl:if test="$nodecounter > 1 and ( $nodecounter + $cols > count($nodeset) ) and count($nodeset) mod $cols != 0">
				<xsl:apply-templates select="$nodeset[1]" mode="TableGeneratorColumn">
					<xsl:with-param name="emptycounter" select="$cols - ( count($nodeset) mod $cols )" />
				</xsl:apply-templates>
			</xsl:if>
		</tr>
		<xsl:if test="$nodecounter + $cols &lt;= count($nodeset)">
			<xsl:call-template name="TableGenerator">
				<xsl:with-param name="cols" select="$cols" />
				<xsl:with-param name="nodecounter" select="$nodecounter + $cols" />
				<xsl:with-param name="nodeset" select="$nodeset" />
				<xsl:with-param name="trid" select="$trid" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="TableGeneratorColumn">
		<xsl:param name="emptycounter" select="0" />
		<xsl:param name="rownode" select="1" />
		<xsl:param name="total" select="1" />
		<xsl:variable name="current" select="$rownode + position() - 1" />
		<td>
			<xsl:choose>
				<xsl:when test="$emptycounter > 0">
					&#160;
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select=".">
						<xsl:with-param name="current" select="$current" />
						<xsl:with-param name="total" select="$total" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:if test="$emptycounter > 1">
			<xsl:apply-templates select="." mode="TableGeneratorColumn">
				<xsl:with-param name="emptycounter" select="$emptycounter - 1" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	
	
	
	
	


	<!-- DataTable Generator -->

	<xsl:template name="DataTableGenerator">
		<xsl:param name="cols" select="2" />
		<xsl:param name="nodeset" />
		<xsl:param name="nodecounter" select="1" />
		<xsl:variable name="skip" select="ceiling( count($nodeset) div $cols )" />
		<td valign="top">
			<xsl:element name="table" use-attribute-sets="DataTableAttr">
				<xsl:apply-templates select="$nodeset[(position() >= $nodecounter) and (position() &lt; ($nodecounter + $skip))]" mode="DataTableElement" />
			</xsl:element>
		</td>
		<xsl:if test="($nodecounter + $skip) &lt;= count($nodeset)">
			<xsl:call-template name="DataTableGenerator">
				<xsl:with-param name="cols" select="$cols" />
				<xsl:with-param name="nodecounter" select="$nodecounter + $skip" />
				<xsl:with-param name="nodeset" select="$nodeset" />
				<xsl:with-param name="skip" select="$skip" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	
	
	
	
	
	<!-- Link for hiding & displaying data -->
		
	<xsl:template name="ToggleDisplayImage">
		<img onPropertyChange="JavaScript:toggleImageChanged();" src="images/arrow_down.gif" id="toggleImage" align="absmiddle" />
	</xsl:template>

	
	

	

	
	
	
	<!-- Template for calculating power -->
	
	<xsl:template name="power">
		<xsl:param name="base" select="1" />
		<xsl:param name="exp" select="1" />
		<xsl:param name="factor" select="1" />
		<xsl:param name="result" select="$base" />

		<xsl:choose>
			<xsl:when test="$exp > 1">
				<xsl:call-template name="power">
					<xsl:with-param name="base" select="$base" />
					<xsl:with-param name="exp" select="$exp - 1" />
					<xsl:with-param name="factor" select="$factor" />
					<xsl:with-param name="result" select="$result * $base" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$exp = 1">
				<xsl:value-of select="$result * $factor"/>
			</xsl:when>
			
			<xsl:when test="$exp &lt; -1">
				<xsl:call-template name="power">
					<xsl:with-param name="base" select="$base" />
					<xsl:with-param name="exp" select="$exp + 1" />
					<xsl:with-param name="factor" select="$factor" />
					<xsl:with-param name="result" select="$result * $base" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$exp = -1">
				<xsl:value-of select="( 1 div $result ) * $factor"/>
			</xsl:when>	
			
			<xsl:when test="$exp = 0">
				<xsl:value-of select="$factor"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	

	
	

	<!-- That's it -->
	
</xsl:stylesheet>

