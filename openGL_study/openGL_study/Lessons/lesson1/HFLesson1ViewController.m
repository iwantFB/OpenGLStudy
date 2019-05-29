//
//  HFLesson1ViewController.m
//  openGL_study
//
//  Created by 胡斐 on 2019/5/28.
//  Copyright © 2019 jackson. All rights reserved.
//

/*
 该部分内容都可以在
 https://learnopengl-cn.readthedocs.io/zh/latest/01%20Getting%20started/04%20Hello%20Triangle/
 内找到详细解释
 */

#import "HFLesson1ViewController.h"
#import <GLKit/GLKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface HFLesson1ViewController ()<GLKViewDelegate>
@property (nonatomic, strong) EAGLContext *glContext;
//着色器
@property (nonatomic, strong) GLKBaseEffect *mEffect;
@property (nonatomic, strong) GLKView *glView;
@end

@implementation HFLesson1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
    [self _dealWithVertexArr];
    [self _configTexture];
}

#pragma mark- private method
- (void)_setupUI
{
    [self.view addSubview:self.glView];
    self.glView.context = self.glContext;
    //新建gl上下文
    [EAGLContext setCurrentContext:self.glContext];
}

- (void)_dealWithVertexArr
{
    // 顶点坐标和纹理坐标都是 0～1 ，顶点坐标的中心点是在屏幕中心 而纹理坐标的中心点在左下角
    //以数组的形式传递三个3D坐标作为图形渲染管线的输入，表示三角形，该数组叫顶点数据(vertexData)
    //顶点数据是一系列顶点(3D坐标的数据的集合)的集合
    //顶点数据用顶点属性(VertexAttribute)表示
    GLfloat vertexData[] =
    {
        0.5,  -0.5,  0.0f,   1.0f, 0.0f, //右下
        0.5,   0.5,  0.0f,   1.0f, 1.0f, //右上
        -0.5,  0.5,  0.0f,   0.0f, 1.0f, //左上
        
        0.5,  -0.5,  0.0f,   1.0f, 0.0f, //右下
        -0.5,  0.5,  0.0f,   0.0f, 1.0f, //左上
        -0.5, -0.5,  0.0f,   0.0f, 0.0f, //左下
    };
    
    //顶点数据缓存
    GLuint buffer;
    //第一个参数为d缓存ID
    glGenBuffers(1, &buffer);
    //OpenGL有很多缓冲对象类型，顶点缓冲对象(VBO)的缓冲类型是GL_ARRAY_BUFFER
    //将新创建的缓冲绑定到GL_ARRAY_BUFFER目标上
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    //将VBO复制到缓冲的内存中，参数作用如下
    // 指定缓冲类型 ：将VBO绑定在GL_ARRAY_BUFFER
    // 指定传输数据的大小
    // 实际发送的数据
    // 显卡如何管理给定的数据，有三种类型 GL_STATIC_DRAW ：数据不会或几乎不会改变。 GL_DYNAMIC_DRAW：数据会被改变很多。 GL_STREAM_DRAW ：数据每次绘制时都会改变。
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), &vertexData, GL_STATIC_DRAW);
    //设置顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置顶点属性指针，配置属性
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
}

- (void)_configTexture
{
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"lesson1" ofType:@"jpg"];
    //GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    NSDictionary* options = @{
                              GLKTextureLoaderOriginBottomLeft : @1,
                              };
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.mEffect.texture2d0.name = textureInfo.name;
}

#pragma mark- GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    //配置背景色
    glClearColor(0.4f, 0.6f, 0.6f, 1.0f);
    //设置背景色
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    
    //在OpenGl中所有的图形都是通过分解成三角形的方式进行绘制。
    /*
     glDrawArrays(int mode, int first,int count)
     
     参数1：计划绘制的图元类型 有三种取值
     
     1.GL_TRIANGLES：每三个顶之间绘制三角形，之间不连接
     
     2.GL_TRIANGLE_FAN：以V0V1V2,V0V2V3,V0V3V4，……的形式绘制三角形
     
     3.GL_TRIANGLE_STRIP：顺序在每三个顶点之间均绘制三角形。
     这个方法可以保证从相同的方向上所有三角形均被绘制。以V0V1V2,V1V2V3,V2V3V4……的形式绘制三角形

     参数2：从数组缓存中的哪一位开始绘制，一般都定义为0
     
     参数3：顶点的数量
     */
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

#pragma mark- setter/getter
- (EAGLContext *)glContext
{
    if(!_glContext){
        //api 支持的GL ES的版本
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    return _glContext;
}

- (GLKView *)glView
{
    if(!_glView){
        _glView = [[GLKView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds))];
        //缓冲的颜色格式，改变的之后，会在下次绘制的重新生成缓冲对象
        _glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
        _glView.delegate = self;
    }
    return _glView;
}

- (GLKBaseEffect *)mEffect
{
    if(!_mEffect){
        _mEffect = [[GLKBaseEffect alloc] init];
        _mEffect.texture2d0.enabled = GL_TRUE;
    }
    return _mEffect;
}

@end

#pragma clang diagnostic pop
