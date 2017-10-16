void main() {
    vec4 color = texture2D(u_texture, v_tex_coord);
    gl_FragColor = color * vec4(mix(bottomColor, topColor, v_tex_coord.y));
//    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
