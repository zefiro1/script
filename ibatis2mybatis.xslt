<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template name="mybatisDoctype">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd"&gt;</xsl:text>
    </xsl:template>

    <!-- Agregar la declaración del doctype de MyBatis -->
    <xsl:template match="/">
        <xsl:call-template name="mybatisDoctype" />
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="text() | @*">
        <xsl:copy />
    </xsl:template>
    <xsl:template match="resultMap">
        <resultMap id="{@id}">
            <xsl:if test="@class">
                <xsl:attribute name="type">
                    <xsl:value-of select="@class" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </resultMap>
    </xsl:template>
    <xsl:template match="resultMap/result">
        <result property="{@property}">
            <xsl:if test="@column">
                <xsl:attribute name="column">
                    <xsl:value-of select="@column" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </result>
    </xsl:template>  

    <xsl:template match="//isNotNull">
    <xsl:choose>
        <xsl:when test="@prepend='AND'">
          <if test="{@property} != null">
            <xsl:text>AND </xsl:text>
            <xsl:apply-templates />
          </if>
        </xsl:when>
        <xsl:when test="@prepend=','">
          <if test="{@property} != null">
              <xsl:apply-templates />
              <xsl:text> = </xsl:text>
                <xsl:value-of select="concat('#{', @property, '}')" />
            <xsl:text>, </xsl:text>
          </if>
        </xsl:when>
      </xsl:choose>
    </xsl:template>    


    <xsl:template match="//isNull">
        <if test="{@property} == null">
            <xsl:apply-templates />
        </if>
    </xsl:template>
    <xsl:template match="//include">
        <include refid="{@refid}" />
    </xsl:template>
    <!-- Transforma dynamic en where -->
    <xsl:template match="dynamic[@prepend='WHERE']">
        <where>
            <xsl:apply-templates />
        </where>
    </xsl:template>
    <xsl:template match="dynamic[@prepend='AND']">
        <where>
            <xsl:text>AND </xsl:text>
            <xsl:apply-templates />
        </where>
    </xsl:template>
    <xsl:template match="dynamic">
        <where>
            <xsl:apply-templates />
        </where>
    </xsl:template>


    <!-- Mantiene el parameterMap -->
    <xsl:template match="parameterMap">
        <parameterMap id="{@id}">
            <xsl:if test="@class">
                <xsl:attribute name="class">
                    <xsl:value-of select="@class" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </parameterMap>
    </xsl:template>
    <!-- Mantiene el parameter -->
    <xsl:template match="parameterMap/parameter">
        <parameter property="{@property}">
            <xsl:if test="@column">
                <xsl:attribute name="column">
                    <xsl:value-of select="@column" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </parameter>
    </xsl:template>

    <xsl:template match="sqlMap">
        <mapper namespace="{@namespace}">
            <xsl:apply-templates />
        </mapper>
    </xsl:template>

    <!-- Renombrar elementos -->
    <xsl:template match="sqlMap">
        <mapper namespace="{@namespace}">
            <xsl:apply-templates />
        </mapper>
    </xsl:template>
    <!-- Cambia el sql por el select-->
    <xsl:template match="sql">
        <sql id="{@id}">
            <xsl:if test="@parameterMap">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterMap" />
                </xsl:attribute>
            </xsl:if>  
         
            <xsl:if test="@resultMap">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultMap" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultType">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterType">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultClass">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </sql>
    </xsl:template>

    <!-- Mantiene el select-->
    <xsl:template match="select">
        <select id="{@id}">
            <xsl:if test="@parameterClass">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultMap">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultMap" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultType">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterType">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultClass">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </select>
    </xsl:template>

    <!-- Mantiene el select-->
    <xsl:template match="insert">
        <insert id="{@id}">
            <xsl:if test="@resultType">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterType">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterClass">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultMap">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultMap" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultClass">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </insert>
    </xsl:template>
    <!-- Mantiene el update-->
    <xsl:template match="update">
        <update id="{@id}">
            <xsl:if test="@resultType">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterType">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterClass">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultMap">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultMap" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultClass">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </update>
    </xsl:template>
    <!-- Mantiene el DELETE-->
    <xsl:template match="delete">
        <delete id="{@id}">
            <xsl:if test="@resultType">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterType">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterType" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@parameterClass">
                <xsl:attribute name="parameterType">
                    <xsl:value-of select="@parameterClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultMap">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultMap" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@resultClass">
                <xsl:attribute name="resultType">
                    <xsl:value-of select="@resultClass" />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </delete>
    </xsl:template>

    <xsl:template match="isEqual">
        <if test="{@property} == '{@compareValue}'">
            <xsl:apply-templates />
        </if>
    </xsl:template>

    <xsl:template match="isEqual/isEqual">
        <if test="{@property} == '{@compareValue}'">
            <xsl:apply-templates />
        </if>
    </xsl:template>
    <xsl:template match="isNotEmpty">
        <if test="{@property} != ''">
            <xsl:apply-templates />
        </if>
    </xsl:template>    
    <xsl:template match="//isGreaterThan">
        <if test="{@property} &gt; '{@compareValue}'">
            <xsl:apply-templates />
        </if>
    </xsl:template>    
    <xsl:template match="//isLessThan">
        <if test="{@property} &lt; '{@compareValue}'">
            <xsl:apply-templates />
        </if>
    </xsl:template>
    
    
</xsl:stylesheet>