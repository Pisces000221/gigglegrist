// 在客户端和服务器端都会加载
// CoffeeScript定义全局变量不方便，所以使用Javascript

GM = {};
GM.rooms = new Meteor.Collection('rooms');
